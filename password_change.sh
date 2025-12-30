#!/bin/bash
set -euo pipefail

ADMIN_EMAIL="souravkr529@gmail.com"

OUT_DIR="/root/password-rotations"
mkdir -p "$OUT_DIR"
chmod 700 "$OUT_DIR"

DATE_STR="$(date +%F)"
TIME_STR="$(date +%T)"
HOSTNAME="$(hostname)"
SERVER_IP="$(hostname -I | awk '{print $1}')"

RUN_TAG="${DATE_STR}_$(date +%H%M%S)"
CSV_FILE="$OUT_DIR/whm_passwords_${RUN_TAG}.csv"
LOG_FILE="$OUT_DIR/whm_passwords_${RUN_TAG}.log"
chmod 600 "$CSV_FILE" "$LOG_FILE" 2>/dev/null || true

# ===== Password policy (safe chars only, avoids WHM CLI parsing issues) =====
PASSWORD_LENGTH=28     # 24-32 recommended
TARGET_STRENGTH=100
MAX_GEN_TRIES=80
MAX_API_TRIES=3

gen_alnum_password() {
  local len="$1"
  while :; do
    # Only A-Z a-z 0-9
    local p
    p="$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c"$len")"
    # ensure at least 1 lower, 1 upper, 1 digit
    [[ "$p" =~ [a-z] ]] || continue
    [[ "$p" =~ [A-Z] ]] || continue
    [[ "$p" =~ [0-9] ]] || continue
    echo "$p"
    return
  done
}

get_domain() {
  local user="$1"
  local userfile="/var/cpanel/users/$user"
  [[ -f "$userfile" ]] || { echo ""; return; }
  awk -F= '/^DNS=/{print $2; exit}' "$userfile" | tr -d '\r'
}

# WHM API: password strength check (per cPanel docs) :contentReference[oaicite:2]{index=2}
get_strength() {
  local pass="$1"
  local out
  out="$(/usr/local/cpanel/bin/whmapi1 --output=json get_password_strength password="$pass" 2>/dev/null || true)"
  # try extract "strength": number
  echo "$out" | sed -n 's/.*"strength"[[:space:]]*:[[:space:]]*\([0-9]\+\).*/\1/p' | head -n1
}

whm_passwd() {
  local user="$1"
  local pass="$2"
  /usr/local/cpanel/bin/whmapi1 --output=json passwd user="$user" password="$pass" 2>&1
}

get_json_field() {
  local json="$1"
  local key="$2"
  echo "$json" | sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\{0,1\}\([^\",}]*\)\"\{0,1\}.*/\1/p" | head -n1
}

# ===== Auto include all cPanel users =====
mapfile -t USERS < <(
  find /var/cpanel/users -maxdepth 1 -type f -printf '%f\n' \
  | grep -E '^[a-z0-9]{1,16}$' \
  | grep -vE '^(nobody|root|cpanel)$' \
  | sort
)

if [[ ${#USERS[@]} -eq 0 ]]; then
  echo "ERROR: No cPanel users found in /var/cpanel/users" | tee -a "$LOG_FILE"
  exit 1
fi

echo "domain,username,new_password,status" > "$CSV_FILE"

SUCCESS_COUNT=0
FAIL_COUNT=0
DETAIL_LINES=""
FAILED_LINES=""

for USER_NAME in "${USERS[@]}"; do
  DOMAIN="$(get_domain "$USER_NAME")"
  DETAIL_LINES+=$'Username: '"$USER_NAME"$'\n'

  if [[ -z "$DOMAIN" ]]; then
    FAIL_COUNT=$((FAIL_COUNT+1))
    FAILED_LINES+="- $USER_NAME : domain not found\n"
    echo ",$USER_NAME,,FAILED" >> "$CSV_FILE"
    continue
  fi

  NEW_PASSWORD=""
  STATUS="FAILED"
  LAST_REASON="Unknown error"
  LAST_OUT=""

  # generate password until strength >= TARGET_STRENGTH
  for ((g=1; g<=MAX_GEN_TRIES; g++)); do
    CAND="$(gen_alnum_password "$PASSWORD_LENGTH")"

    STR="$(get_strength "$CAND")"
    [[ -n "${STR:-}" ]] || STR=0

    if (( STR < TARGET_STRENGTH )); then
      continue
    fi

    # try to set password
    for ((a=1; a<=MAX_API_TRIES; a++)); do
      OUT="$(whm_passwd "$USER_NAME" "$CAND")"
      RES="$(get_json_field "$OUT" "result")"
      REASON="$(get_json_field "$OUT" "reason")"

      if [[ "$RES" == "1" ]]; then
        STATUS="SUCCESS"
        NEW_PASSWORD="$CAND"
        LAST_REASON="OK"
        LAST_OUT="$OUT"
        break
      fi

      LAST_REASON="${REASON:-Unknown error}"
      LAST_OUT="$OUT"

      # if weak/strength error, break api-tries and generate a new candidate
      if [[ "$LAST_REASON" == *"too weak"* || "$LAST_REASON" == *"strength rating"* ]]; then
        break
      fi
    done

    [[ "$STATUS" == "SUCCESS" ]] && break
  done

  if [[ "$STATUS" == "SUCCESS" ]]; then
    SUCCESS_COUNT=$((SUCCESS_COUNT+1))
    echo "$DOMAIN,$USER_NAME,$NEW_PASSWORD,SUCCESS" >> "$CSV_FILE"
  else
    FAIL_COUNT=$((FAIL_COUNT+1))
    FAILED_LINES+="- $USER_NAME ($DOMAIN) : $LAST_REASON\n"
    echo "$DOMAIN,$USER_NAME,,FAILED" >> "$CSV_FILE"
    {
      echo "----- FAILED: $USER_NAME ($DOMAIN) -----"
      echo "$LAST_OUT"
      echo ""
    } >> "$LOG_FILE"
  fi
done

SUBJECT="WHM: Password changed for cPanel users"

BODY="WHM: Password changed for cPanel users

Account included:
$DETAIL_LINES
Password attached to CSV file (no plain password in email)

CSV Columns: domain,username,new_password,status

Summary:
- Total users: ${#USERS[@]}
- Success:     $SUCCESS_COUNT
- Failed:      $FAIL_COUNT

Failed details (no passwords):
${FAILED_LINES:-None}

- Action Date: $DATE_STR $TIME_STR
- Performed by: $(whoami)@$HOSTNAME
- Server: $HOSTNAME ($SERVER_IP)
"

BOUNDARY="====WHM_PASS_ROTATE_$(date +%s)_$$===="
FILENAME="$(basename "$CSV_FILE")"
ATTACH_B64="$(base64 "$CSV_FILE")"

{
  echo "Subject: $SUBJECT"
  echo "To: $ADMIN_EMAIL"
  echo "From: root@$HOSTNAME"
  echo "MIME-Version: 1.0"
  echo "Content-Type: multipart/mixed; boundary=\"$BOUNDARY\""
  echo ""
  echo "--$BOUNDARY"
  echo "Content-Type: text/plain; charset=UTF-8"
  echo ""
  echo "$BODY"
  echo ""
  echo "--$BOUNDARY"
  echo "Content-Type: text/csv; name=\"$FILENAME\""
  echo "Content-Transfer-Encoding: base64"
  echo "Content-Disposition: attachment; filename=\"$FILENAME\""
  echo ""
  echo "$ATTACH_B64"
  echo ""
  echo "--$BOUNDARY--"
} | /usr/sbin/sendmail -t

logger -t "whm-password-change" "Rotation done (Total=${#USERS[@]} Success=$SUCCESS_COUNT Failed=$FAIL_COUNT) CSV=$CSV_FILE LOG=$LOG_FILE"

if [ -t 0 ]; then
  echo "==============================================="
  echo "Password Rotation Summary:"
  echo "Total users: ${#USERS[@]}"
  echo "Success:     $SUCCESS_COUNT"
  echo "Failed:      $FAIL_COUNT"
  echo "CSV File:    $CSV_FILE"
  echo "Log File:    $LOG_FILE"
  echo "Email sent to: $ADMIN_EMAIL"
  echo "==============================================="
fi

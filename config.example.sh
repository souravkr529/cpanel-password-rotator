#!/bin/bash
# =============================================================================
# cPanel Auto Password Change Script - Example Configuration
# =============================================================================
# This is an example configuration showing all customizable parameters
# Copy this section to the top of password_change.sh and modify as needed
# =============================================================================

# ====== EMAIL CONFIGURATION ======
# Email addresses to receive password rotation reports
# Use comma-separated list for multiple recipients
ADMIN_EMAIL="souravkr529@gmail.com"

# ====== OUTPUT DIRECTORY ======
# Directory where CSV and log files will be stored
# Default: /root/password-rotations
OUT_DIR="/root/password-rotations"

# ====== PASSWORD POLICY ======
# Length of generated passwords (recommended: 24-32 characters)
PASSWORD_LENGTH=28

# Minimum WHM password strength score (0-100 scale)
# Recommended: 100 for maximum security
TARGET_STRENGTH=100

# Maximum attempts to generate a password that meets strength requirements
MAX_GEN_TRIES=80

# Maximum retry attempts for WHM API calls
MAX_API_TRIES=3

# =============================================================================
# ADVANCED CONFIGURATION (Optional)
# =============================================================================

# ====== USER FILTERING ======
# By default, the script processes ALL cPanel users
# To exclude specific users, modify the user discovery section:

# Example: Exclude specific accounts
# EXCLUDED_USERS="demo test staging"
# Then modify the find command to:
# | grep -vE "^(nobody|root|cpanel|${EXCLUDED_USERS// /|})$"

# ====== CUSTOM NOTIFICATIONS ======
# To add Slack/Discord notifications, add webhook calls after email sending:

# Slack example:
# SLACK_WEBHOOK="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
# curl -X POST -H 'Content-type: application/json' \
#   --data "{\"text\":\"Password rotation completed: $SUCCESS_COUNT success, $FAIL_COUNT failed\"}" \
#   "$SLACK_WEBHOOK"

# Discord example:
# DISCORD_WEBHOOK="https://discord.com/api/webhooks/YOUR/WEBHOOK"
# curl -X POST -H 'Content-Type: application/json' \
#   --data "{\"content\":\"Password rotation completed: $SUCCESS_COUNT success, $FAIL_COUNT failed\"}" \
#   "$DISCORD_WEBHOOK"

# =============================================================================
# SECURITY NOTES
# =============================================================================
# 1. Keep this configuration file secure (chmod 600)
# 2. Never commit sensitive data to version control
# 3. Use encrypted email (TLS/SSL) for notifications
# 4. Regularly audit the output directory permissions
# 5. Consider encrypting CSV files for long-term storage
# =============================================================================

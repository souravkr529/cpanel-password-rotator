# Security Policy

## 🔐 Supported Versions

We release security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅ Yes            |
| < 1.0   | ❌ No             |

## 🛡️ Security Best Practices

### For Users

When using this script, follow these security best practices:

#### 1. **Secure Script Storage**
```bash
# Store script in protected directory
mkdir -p /root/scripts
chmod 700 /root/scripts
mv password_change.sh /root/scripts/
chmod 700 /root/scripts/password_change.sh
```

#### 2. **Protect Output Files**
```bash
# The script automatically creates files with chmod 600
# Verify permissions regularly:
ls -la /root/password-rotations/
```

#### 3. **Secure Email Delivery**
- Use TLS/SSL for email transmission
- Consider encrypted email solutions for highly sensitive environments
- Limit email recipients to authorized administrators only

#### 4. **Regular Audits**
```bash
# Review who has accessed password files
last -f /root/password-rotations/*

# Check for unauthorized modifications
stat /root/scripts/password_change.sh
```

#### 5. **Backup Securely**
- Encrypt backups of CSV files
- Store backups in secure, access-controlled locations
- Implement backup retention policies

#### 6. **Monitor Execution**
```bash
# Check syslog for script execution
grep "whm-password-change" /var/log/messages

# Review cron execution logs
grep CRON /var/log/cron | grep password_change
```

### For Administrators

#### Password Security

1. **Strong Password Policy**:
   - Minimum length: 24-32 characters (default: 28)
   - Minimum strength score: 100/100
   - Character set: A-Z, a-z, 0-9

2. **Password Rotation Frequency**:
   - Recommended: Every 90 days (quarterly)
   - Maximum: Every 180 days (semi-annually)
   - Minimum: Every 30 days (monthly) for high-security environments

3. **Password Distribution**:
   - Never send passwords in plain text emails
   - Use the CSV attachment feature
   - Consider additional encryption for CSV files
   - Implement secure password sharing mechanisms (e.g., password managers)

#### Access Control

1. **Script Execution**:
   - Only root should execute the script
   - Use `sudo` for controlled access if needed
   - Log all executions

2. **File Access**:
   - Limit access to `/root/password-rotations/` directory
   - Implement file integrity monitoring
   - Regular permission audits

3. **Email Security**:
   - Use multiple recipient emails for redundancy
   - Configure SPF, DKIM, DMARC for email authentication
   - Monitor for email interception

## 🚨 Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. **DO NOT** Create a Public Issue

Security vulnerabilities should **never** be disclosed publicly until a fix is available.

### 2. Report Privately

Send details to:
- **Email**: souravkr529@gmail.com

### 3. Include These Details

Your report should include:

```markdown
## Vulnerability Description
<!-- Clear description of the security issue -->

## Affected Versions
<!-- Which versions are affected? -->

## Attack Scenario
<!-- How can this vulnerability be exploited? -->

## Impact Assessment
<!-- What is the potential impact? (Low/Medium/High/Critical) -->

## Proof of Concept
<!-- Steps to reproduce (if safe to do so) -->

## Suggested Fix
<!-- If you have ideas for fixing the issue -->

## Your Contact Information
<!-- How can we reach you for follow-up? -->
```

### 4. Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 5 business days
- **Status Update**: Every 7 days until resolved
- **Fix Release**: Depends on severity
  - Critical: 1-7 days
  - High: 7-14 days
  - Medium: 14-30 days
  - Low: 30-90 days

### 5. Disclosure Policy

- We'll work with you to understand and fix the issue
- We'll credit you in the security advisory (unless you prefer to remain anonymous)
- We'll coordinate public disclosure after a fix is available
- Typical disclosure timeline: 90 days after initial report

## 🔍 Security Considerations

### Threat Model

This script handles sensitive credentials. Consider these threats:

#### 1. **Unauthorized Access**
- **Risk**: Unauthorized users accessing password files
- **Mitigation**: File permissions (600/700), access controls

#### 2. **Man-in-the-Middle Attacks**
- **Risk**: Interception of email notifications
- **Mitigation**: Use encrypted email (TLS/SSL), VPN

#### 3. **Privilege Escalation**
- **Risk**: Non-root users gaining access to passwords
- **Mitigation**: Strict file permissions, audit logs

#### 4. **Social Engineering**
- **Risk**: Attackers tricking admins into revealing passwords
- **Mitigation**: Security awareness training, multi-factor authentication

#### 5. **Insider Threats**
- **Risk**: Malicious insiders accessing password files
- **Mitigation**: Audit logs, least privilege principle, monitoring

### Security Hardening Checklist

- [ ] Script stored in `/root/scripts/` with `chmod 700`
- [ ] Output directory has `chmod 700` permissions
- [ ] Output files have `chmod 600` permissions
- [ ] Email uses TLS/SSL encryption
- [ ] Cron job configured correctly
- [ ] Syslog monitoring enabled
- [ ] Regular security audits scheduled
- [ ] Backup encryption implemented
- [ ] Access logs reviewed regularly
- [ ] Multi-factor authentication for admin access

## 🔒 Encryption Recommendations

### Encrypt CSV Files (Optional)

For high-security environments, consider encrypting CSV files:

```bash
# Install GPG (if not already installed)
yum install -y gnupg2

# Encrypt CSV file
gpg -c /root/password-rotations/whm_passwords_2024-12-30.csv

# This creates whm_passwords_2024-12-30.csv.gpg
# Securely delete original:
shred -u /root/password-rotations/whm_passwords_2024-12-30.csv
```

### Automated Encryption

Modify the script to auto-encrypt:

```bash
# Add after CSV creation
if command -v gpg &> /dev/null; then
  gpg -c --batch --passphrase-file /root/.gpg-pass "$CSV_FILE"
  shred -u "$CSV_FILE"
  CSV_FILE="${CSV_FILE}.gpg"
fi
```

## 📊 Security Audit Log

Maintain a security audit log:

```bash
# Log file location
/root/security-audit/password_rotation_audit.log

# Log entry format
[2024-12-30 23:55:00] Script executed by root from 192.168.1.100
[2024-12-30 23:55:15] 15 passwords rotated (14 success, 1 failed)
[2024-12-30 23:55:16] Email sent to admin@example.com
[2024-12-30 23:55:16] CSV file created: whm_passwords_2024-12-30_235500.csv
```

## 🆘 Incident Response

If you suspect a security breach:

### 1. Immediate Actions
```bash
# Rotate all passwords immediately
/root/scripts/password_change.sh

# Check for unauthorized access
last -f /var/log/wtmp
last -f /var/log/btmp

# Review file access
aureport -f | grep password-rotations
```

### 2. Investigation
- Review system logs
- Check email logs
- Audit file access logs
- Interview relevant personnel

### 3. Remediation
- Change compromised passwords
- Update security policies
- Implement additional controls
- Document lessons learned

### 4. Reporting
- Notify relevant stakeholders
- File incident report
- Update security procedures

## 📞 Contact

For security-related questions or concerns:

- **Email**: souravkr529@gmail.com

## 📜 Compliance

This script can help meet compliance requirements for:

- **PCI DSS**: Regular password rotation (Requirement 8.2.4)
- **HIPAA**: Access control and audit logs
- **SOC 2**: Security monitoring and logging
- **GDPR**: Data protection and access controls

---

**Security is a shared responsibility. Stay vigilant! 🛡️**

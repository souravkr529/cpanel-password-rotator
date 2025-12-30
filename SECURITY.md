# Security Policy

## 🔐 Reporting Security Issues

If you discover a security vulnerability, please email:
- **souravkr529@gmail.com**

Do NOT create public issues for security vulnerabilities.

## 🛡️ Security Best Practices

### 1. Protect the Script
```bash
chmod 700 /root/scripts/password_change.sh
chown root:root /root/scripts/password_change.sh
```

### 2. Protect Output Files
```bash
# Files automatically created with chmod 600
# Verify regularly:
ls -la /root/password-rotations/
```

### 3. Use Encrypted Email
- Enable TLS/SSL for email transmission
- Consider encrypted email for sensitive environments

### 4. Regular Audits
```bash
# Review access logs
last -f /root/password-rotations/*

# Check cron execution
grep CRON /var/log/cron | grep password_change
```

### 5. Password Rotation Schedule
- **Recommended:** Every 90 days (quarterly)
- **Maximum:** Every 180 days
- **High-security:** Every 30 days

## 🔒 Security Features

✅ Cryptographically secure random generation (`/dev/urandom`)  
✅ Strong passwords (28 chars minimum)  
✅ WHM strength validation (100/100 score)  
✅ Secure file permissions (600/700)  
✅ No passwords in logs or email body  
✅ Base64-encoded CSV attachments

---

**Security is a shared responsibility. Stay vigilant! 🛡️**

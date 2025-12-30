# Quick Start Guide 🚀

This guide will help you get the cPanel Auto Password Change script running in just a few minutes.

## Prerequisites Checklist

- [ ] Server with cPanel/WHM installed
- [ ] Root access to the server
- [ ] Sendmail or working mail system
- [ ] Basic knowledge of SSH and Bash scripts

## Installation Steps

### 1. Download the Script

**Option A: Using Git (Recommended)**
```bash
cd /root
git clone https://github.com/yourusername/cpanel-auto-password-change.git
```

**Option B: Manual Download**
```bash
cd /root
wget https://github.com/yourusername/cpanel-auto-password-change/archive/refs/heads/main.zip
unzip main.zip
mv cpanel-auto-password-change-main cpanel-auto-password-change
```

### 2. Setup the Script

```bash
# Create scripts directory
mkdir -p /root/scripts

# Copy the script
cp /root/cpanel-auto-password-change/password_change.sh /root/scripts/

# Set permissions
chmod 700 /root/scripts/password_change.sh
chown root:root /root/scripts/password_change.sh
```

### 3. Configure Email

Edit the script and update your email address:

```bash
nano /root/scripts/password_change.sh
```

Find and modify this line (around line 4):
```bash
ADMIN_EMAIL="your-email@example.com"
```

Save the file: `Ctrl + X`, then `Y`, then `Enter`

### 4. Test the Script

**IMPORTANT: Test on a test server first!**

```bash
# Run the script manually
/root/scripts/password_change.sh
```

You should see output like:
```
===============================================
Password Rotation Summary:
Total users: 5
Success:     5
Failed:      0
CSV File:    /root/password-rotations/whm_passwords_2024-12-30_140500.csv
Log File:    /root/password-rotations/whm_passwords_2024-12-30_140500.log
Email sent to: your-email@example.com
===============================================
```

### 5. Check Email

Within a few minutes, you should receive an email with:
- Subject: "WHM: Password changed for cPanel users"
- Body: Summary of the operation
- Attachment: CSV file with new passwords

### 6. Schedule Automation (Optional)

To run automatically every month:

```bash
crontab -e
```

Add this line:
```bash
# Run on 26th of every month at 11:55 PM
55 23 26 * * /root/scripts/password_change.sh > /dev/null 2>&1
```

Save and exit.

Verify the cron job:
```bash
crontab -l
```

## Customization Options

### Change Password Length

Edit `/root/scripts/password_change.sh` and modify line 21:
```bash
PASSWORD_LENGTH=32  # Change from default 28 to 32
```

### Change Password Strength

Edit line 22:
```bash
TARGET_STRENGTH=100  # Keep at 100 for maximum security
```

### Add Multiple Email Recipients

Edit line 4:
```bash
ADMIN_EMAIL="admin@example.com,security@example.com,backup@example.com"
```

## Common Cron Schedules

```bash
# Every Sunday at 2 AM
0 2 * * 0 /root/scripts/password_change.sh > /dev/null 2>&1

# Every first day of the month at midnight
0 0 1 * * /root/scripts/password_change.sh > /dev/null 2>&1

# Every 3 months (quarterly)
0 0 1 */3 * /root/scripts/password_change.sh > /dev/null 2>&1

# Every 6 months (bi-annually)
0 0 1 */6 * /root/scripts/password_change.sh > /dev/null 2>&1
```

## Troubleshooting Quick Fixes

### Problem: Email not received

**Solution 1:** Test sendmail
```bash
echo "Test email" | mail -s "Test" your-email@example.com
```

**Solution 2:** Check mail logs
```bash
tail -f /var/log/maillog
```

### Problem: Permission denied

**Solution:** Ensure you're running as root
```bash
sudo /root/scripts/password_change.sh
```

### Problem: No users found

**Solution:** Verify cPanel user files exist
```bash
ls -la /var/cpanel/users/
```

## Security Best Practices

1. **Protect the CSV files:**
   ```bash
   chmod 600 /root/password-rotations/*.csv
   ```

2. **Encrypt sensitive files (optional):**
   ```bash
   gpg -c /root/password-rotations/whm_passwords_*.csv
   ```

3. **Regular cleanup:**
   ```bash
   # Delete CSV files older than 90 days
   find /root/password-rotations/ -name "*.csv" -mtime +90 -delete
   ```

## Next Steps

- ✅ Review the full [README.md](README.md) for detailed documentation
- ✅ Check [SECURITY.md](SECURITY.md) for security best practices
- ✅ Read [CONTRIBUTING.md](CONTRIBUTING.md) if you want to contribute
- ✅ Set up monitoring for the cron job execution
- ✅ Create a backup policy for password files

## Getting Help

If you encounter issues:
1. Check the log file: `/root/password-rotations/whm_passwords_*.log`
2. Review [troubleshooting section](README.md#troubleshooting)
3. Open an issue on GitHub
4. Contact: souravkr529@gmail.com

---

**🎉 Congratulations! Your cPanel password rotation is now automated!**

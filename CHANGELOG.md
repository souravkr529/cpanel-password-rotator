# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-30

### Added
- Initial release of cPanel Auto Password Change script
- Automated password rotation for all cPanel accounts
- WHM API integration for password strength validation
- Email notifications with CSV attachments
- Comprehensive logging system
- Retry logic for password generation and API calls
- Secure file permissions (600/700)
- Syslog integration
- Domain auto-detection for users
- Configurable password policy (length, strength, retries)
- Base64-encoded CSV email attachments
- Detailed success/failure reporting

### Security
- Strong alphanumeric password generation (A-Z, a-z, 0-9)
- Cryptographically secure random generation using /dev/urandom
- Minimum password strength validation (100/100 score)
- Protected output directory (chmod 700)
- Protected output files (chmod 600)
- No plain-text passwords in email body
- No passwords in system logs

### Documentation
- Comprehensive README.md with installation and usage guides
- MIT License
- Contributing guidelines (CONTRIBUTING.md)
- Security policy (SECURITY.md)
- Cron scheduling examples
- Troubleshooting guide

## [Unreleased]

### Planned Features
- Multi-server support
- Custom character set support for passwords
- Webhook notifications
- Password encryption option
- Configuration file support
- Advanced email templates
- Integration with password managers
- Custom exclusion/inclusion lists
- Dry-run mode for testing

---

## Version History

- **v1.0.0** (2024-12-30): Initial release with core functionality

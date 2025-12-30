# Changelog

## [1.0.0] - 2024-12-30

### Added
- Initial release
- Automatic password rotation for all cPanel accounts
- WHM API integration for password strength validation
- Email notifications with CSV attachments
- Secure file permissions (600/700)
- Comprehensive logging
- Retry logic for password generation and API calls

### Security
- Strong alphanumeric password generation (28 characters)
- Cryptographically secure random generation
- Minimum password strength: 100/100
- No passwords in email body or logs

# Contributing to cPanel Auto Password Change

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## 🎯 Ways to Contribute

- 🐛 Report bugs and issues
- 💡 Suggest new features or enhancements
- 📝 Improve documentation
- 🔧 Submit bug fixes
- ✨ Add new features
- 🧪 Write tests
- 🌍 Translate documentation

## 📋 Before You Start

1. **Check existing issues**: Look through existing issues to see if your bug/feature has already been reported
2. **Create an issue**: For new bugs or features, create an issue first to discuss the changes
3. **Fork the repository**: Fork the project to your own GitHub account

## 🔧 Development Setup

1. **Fork and clone the repository**:
```bash
git clone https://github.com/yourusername/cpanel-auto-password-change.git
cd cpanel-auto-password-change
```

2. **Create a feature branch**:
```bash
git checkout -b feature/your-feature-name
```

3. **Test environment**: Ensure you have access to a cPanel/WHM test server for testing

## 📝 Coding Standards

### Bash Script Guidelines

- Use **4 spaces** for indentation (no tabs)
- Add **comments** for complex logic
- Use **meaningful variable names** (uppercase for globals, lowercase for locals)
- Follow **Bash best practices**:
  ```bash
  # Good
  set -euo pipefail
  local user_name="$1"
  
  # Avoid
  user=$1
  ```
- **Quote variables** to prevent word splitting: `"$variable"`
- Use **functions** for reusable code
- Add **error handling** for all operations

### Documentation Standards

- Use **clear, concise language**
- Include **code examples** where appropriate
- Add **screenshots** for UI-related changes
- Keep **line length** under 100 characters for readability
- Use **proper markdown formatting**

## 🧪 Testing

Before submitting your pull request:

1. **Test on a test server**: Never test on production!
2. **Test different scenarios**:
   - Single user
   - Multiple users
   - Failed password changes
   - Email delivery
   - Cron execution
3. **Verify output files**: Check CSV and log files
4. **Test error handling**: Verify script handles errors gracefully

## 📤 Submitting Changes

### Commit Messages

Use clear, descriptive commit messages:

```bash
# Good
git commit -m "Add support for custom password character sets"
git commit -m "Fix email attachment encoding issue"
git commit -m "Update documentation for cron scheduling"

# Avoid
git commit -m "update"
git commit -m "fix bug"
```

### Pull Request Process

1. **Update documentation**: Ensure README.md reflects your changes
2. **Update CHANGELOG.md**: Add entry for your changes
3. **Create pull request**: 
   - Use a clear, descriptive title
   - Reference any related issues
   - Describe what changed and why
   - Include testing details

### Pull Request Template

```markdown
## Description
<!-- Describe your changes -->

## Related Issue
<!-- Link to related issue, e.g., "Fixes #123" -->

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
<!-- Describe how you tested your changes -->

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tested on test server
- [ ] CHANGELOG.md updated
```

## 🐛 Reporting Bugs

### Bug Report Template

When reporting bugs, please include:

1. **Description**: Clear description of the bug
2. **Steps to Reproduce**:
   ```
   1. Run the script with...
   2. Check the output...
   3. See error...
   ```
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happened
5. **Environment**:
   - OS: CentOS 7
   - cPanel/WHM Version: 110.0.18
   - Bash Version: 4.2.46
6. **Logs**: Relevant log excerpts or error messages
7. **Screenshots**: If applicable

## 💡 Suggesting Features

### Feature Request Template

When suggesting features:

1. **Problem Statement**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **Alternatives Considered**: Other approaches you've thought about
4. **Additional Context**: Screenshots, examples, etc.

## 🔐 Security Issues

**Please do not open public issues for security vulnerabilities.**

Instead, email security details to:
- souravkr529@gmail.com

We'll work with you to address the issue promptly.

## 📜 Code of Conduct

### Our Standards

- **Be respectful**: Treat everyone with respect
- **Be constructive**: Provide constructive feedback
- **Be collaborative**: Work together towards common goals
- **Be patient**: Remember that people have different skill levels

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

## 📞 Getting Help

If you need help:

1. **Check documentation**: Review README.md and existing issues
2. **Create an issue**: Ask your question in a new issue
3. **Email maintainer**: For private questions, email the author

## 🏆 Recognition

Contributors will be recognized in:

- **Contributors section** in README.md
- **CHANGELOG.md** for significant contributions
- **GitHub contributors** page

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing! 🙏**

Your contributions help make this project better for everyone.

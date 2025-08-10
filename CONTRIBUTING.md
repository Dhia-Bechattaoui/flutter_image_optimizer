# Contributing to Flutter Image Optimizer

Thank you for your interest in contributing to Flutter Image Optimizer! This document provides guidelines and information for contributors.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed steps to reproduce the bug
- Provide information about your environment (OS, Flutter version, etc.)
- Include error messages and stack traces if applicable

### Suggesting Enhancements

- Use the GitHub issue tracker with the "enhancement" label
- Describe the feature you'd like to see
- Explain why this feature would be useful
- Provide examples of how it would work

### Contributing Code

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## Development Setup

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.0.0 or higher)
- Git

### Setup Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/Dhia-Bechattaoui/flutter_image_optimizer.git
   cd flutter_image_optimizer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run tests:
   ```bash
   flutter test
   ```

4. Run the example app:
   ```bash
   cd example
   flutter run
   ```

## Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use the provided `analysis_options.yaml` configuration
- Run `flutter analyze` before submitting changes
- Ensure all linting rules pass

## Testing

- Write tests for all new functionality
- Ensure existing tests continue to pass
- Aim for high test coverage
- Test on multiple platforms when possible

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests on specific platform
flutter test --platform chrome
```

## Documentation

- Update README.md for new features
- Add inline documentation for public APIs
- Update CHANGELOG.md for significant changes
- Include usage examples

## Pull Request Guidelines

- Provide a clear description of the changes
- Include tests for new functionality
- Ensure all CI checks pass
- Update documentation as needed
- Follow the commit message conventions

### Commit Message Format

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `chore`: Build or tooling changes

## Release Process

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create a release tag
4. Publish to pub.dev

## Questions or Need Help?

- Open an issue for questions
- Join our community discussions
- Check existing documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to Flutter Image Optimizer! 🚀

# Contributing to ClipBar

Thank you for your interest in contributing to ClipBar! Contributions are welcome and appreciated. This document provides guidelines for reporting bugs, suggesting features, and submitting code changes.

## Reporting Issues

### Before Reporting

- Check existing [Issues](https://github.com/yourusername/ClipBar/issues) to avoid duplicates
- For security vulnerabilities, please see [SECURITY.md](SECURITY.md)
- Include your macOS version and ClipBar version in the report

### How to Report

Open a new issue with:

- **Clear title** – Describe the problem in one line
- **macOS version** – The version you're running (e.g., macOS 14.2)
- **Steps to reproduce** – Exact steps to trigger the issue
- **Expected vs. actual behavior** – What should happen vs. what happens
- **Logs or screenshots** – If applicable, attach error messages or visual evidence

## Suggesting Features

- Check existing [Issues](https://github.com/yourusername/ClipBar/issues) first
- Describe the use case and how the feature would help
- Provide context: "I need this because..."
- Be realistic about scope (this is a menu bar clipboard manager, not a full office suite)

## Submitting Pull Requests

### Before You Start

1. **Fork the repository** – Click "Fork" on GitHub
2. **Clone your fork** – `git clone https://github.com/yourusername/ClipBar.git`
3. **Create a branch** – `git checkout -b feature/your-feature-name`

### Code Style & Standards

- **Swift conventions** – Follow Apple's [Swift API Guidelines](https://swift.org/documentation/api-design-guidelines/)
- **Naming** – Use clear, descriptive names (`loadClipboardHistory` not `load`)
- **Formatting** – Use standard Xcode formatting (4 spaces, not tabs)
- **Comments** – Add comments for non-obvious logic; avoid redundant comments
- **No refactoring** – Keep PRs focused on a single feature or fix, not sweeping refactors

### Making Changes

1. **Make small, focused changes** – One feature or bug fix per PR
2. **Test locally** – Build and run the app in Xcode to verify changes
3. **Check for regressions** – Ensure existing features still work
4. **No code signing changes** – Do not modify bundle IDs, provisioning profiles, or signing settings
5. **No paid features** – ClipBar is free and open-source

### Committing

- **Clear commit messages** – "Add pause button" not "stuff"
- **Atomic commits** – One logical change per commit
- **No merge commits** – Rebase if pulling latest changes

```bash
git add .
git commit -m "Add clipboard pause feature"
```

### Pushing & Creating a PR

```bash
git push origin feature/your-feature-name
```

Then open a pull request on GitHub with:

- **Title** – Describe the change concisely
- **Description** – Explain why this change is needed
- **Linked issues** – Reference related issues (e.g., "Fixes #42")

## Review Process

- **Maintainer review** – Your PR will be reviewed for code quality, design, and alignment with the project
- **Feedback** – Address comments and push updates to the same branch
- **Approval & merge** – Once approved, your PR will be merged

## Development Tips

### Building from Source

```bash
cd ClipBar/ClipBar
open ClipBar.xcodeproj
# Build with Cmd+B
# Run with Cmd+R
```

### Key Files

- **ClipBarApp.swift** – App entry point
- **AppDelegate.swift** – Lifecycle and menu bar setup
- **ClipboardManager.swift** – Core clipboard monitoring and history
- **MenuController.swift** – Menu bar UI and interactions
- **ClipboardItem.swift** – Data model for clipboard items

### Testing

- Test manual clipboard operations (copy, paste, pin/unpin)
- Verify menu updates reflect changes
- Test with various content types: plain text, URLs, images, file paths
- Confirm app launches on login (if enabled)
- Verify pause/resume functionality

## License

By contributing, you agree that your work will be licensed under the [MIT License](LICENSE).

## Questions?

Open an issue with the label `question` or reach out to the maintainer.

Thank you for contributing to ClipBar! 🎉

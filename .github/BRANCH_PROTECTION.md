# Branch Protection Rules

This document describes the branch protection rules for the ClipBar repository.

## Main Branch Protection

The `main` branch is protected to ensure code quality and prevent accidental changes.

### Rules

1. **Direct Push Restrictions**
   - Only the repository owner (@sanjeevkse) can push directly to `main`
   - All other contributors must create pull requests

2. **Code Review Requirements**
   - All pull requests require approval from @sanjeevkse (defined in `.github/CODEOWNERS`)
   - This ensures that all changes are reviewed before being merged

3. **Automated Checks**
   - The `branch-protection.yml` workflow validates push permissions
   - Pull requests automatically trigger validation checks

## For Contributors

If you want to contribute to ClipBar:

1. **Fork the repository** or **create a feature branch**
2. **Make your changes** in your branch
3. **Create a pull request** to merge your changes into `main`
4. **Wait for review** from @sanjeevkse
5. Once approved, the repository owner will merge your changes

## Setting Up GitHub Branch Protection (For Repository Owner)

In addition to the CODEOWNERS file and workflows, the repository owner should configure the following settings in GitHub:

1. Go to **Settings** → **Branches**
2. Add a branch protection rule for `main`:
   - ✅ Require pull request reviews before merging
   - ✅ Require review from Code Owners
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Include administrators (optional - enforces rules even for owner)
   - ✅ Restrict who can push to matching branches (add only: sanjeevkse)

## Files

- `.github/CODEOWNERS` - Defines who must review changes
- `.github/workflows/branch-protection.yml` - Automated enforcement workflow
- `.github/BRANCH_PROTECTION.md` - This documentation file

# Workflow for Managing Pub.dev Packages

## Workflows

**This repository contains GitHub Actions workflows that simplify the management of your pub.dev packages:**

- The `prepare.yaml` workflow triggers on every push to the main branch. It automatically updates the CHANGELOG.md, formats the Dart code, and applies Dart fixes with each push.
- The `publish.yaml` workflow activates upon the creation of a new release, automatically handling the package's publication to pub.dev.

## Setup Instructions

**1. Navigate to your project:**

```zsh
cd your_project
```

**2. Clone this repo into a `.github/` folder:**

```zsh
git clone https://github.com/dev-cetera/pub.dev_package_workflow.git .github
```

**3. Remove the `/.git` folder to include it to your project:**

_On macOS and Linux:_

```zsh
rm -rf .github/.git/
```

_On Windows:_

```cmd
rmdir /s /q .github/.git/
```

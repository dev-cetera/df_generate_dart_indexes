# pub.dev_package_workflow

This repository provides a powerful and streamlined set of GitHub Actions workflows designed to automate the entire lifecycle of your Dart and Flutter packages—from version bumping and changelog generation to publishing on pub.dev and deploying examples to GitHub Pages.

---

## 🚀 Core Features

- **Automated Version Bumping:** Automatically update `CHANGELOG.md`, `README.md`, and other files when you're ready to release.
- **Git Tagging:** Automatically create and push Git tags for new versions.
- **Flexible Publishing Triggers:** Publish packages automatically via special commit messages or by creating a release in the GitHub UI.
- **Example App Deployment:** An optional workflow to build and deploy a Flutter web example to GitHub Pages.

## Workflows

This project contains three key GitHub Actions workflows.

### 1. `process-package.yml`

This is the primary workflow for managing releases directly from your commit messages. It triggers on every push to your `main` branch.

- **Standard Commits:** For any normal commit message, the workflow does nothing.
- **Prepare a Release (`+`):** If your commit message starts with a single plus sign (e.g., `+Added new feature`), the workflow will:
    - Run `dart format` and `dart fix --apply`.
    - Update your `CHANGELOG.md` with the commit message.
    - Generate a standardized `README.md` from a central template.
    - Commit these automated changes with the message `ci: bump version to v[version]`.
    - Create and push a Git tag for the new version.
- **Prepare and Publish (`++`):** If your commit message starts with two plus signs (e.g., `++Major performance improvements`), the workflow will do **everything above** and then automatically **publish the package to pub.dev** if properly configured. See https://dart.dev/tools/pub/automated-publishing.

### 2. `publish.yml`

This workflow provides a manual trigger for publishing. It activates **only** when you create a new release in the GitHub UI. This is perfect for when you want to review changes on the `main` branch before deciding to publish.

### 3. `deploy-example.yml` (Optional)

If your project contains a Flutter web example in a `hosted_example` directory, this workflow will automatically build it and deploy it to GitHub Pages on every push to the `main` branch. This is great for providing live demos of your package.

---

## 🛠️ Setup Instructions

Setting up these workflows in your own package repository is simple.

**1. Navigate to Your Project's Root Directory**

Open your terminal and `cd` into the root of your Dart or Flutter package.

```zsh
cd /path/to/your_project
```

**2. Clone this Workflow Repository**

Clone this repository directly into a `.github` folder. This will create `.github/workflows` and `.github/scripts` for you.

```zsh
git clone https://github.com/dev-cetera/pub.dev_package_workflow.git .github
```

**3. Remove the Nested `.git` Directory**

To make these workflow files part of your own project's Git history, you must delete the nested `.git` directory that was just cloned.

**4. Configure `pub.dev` for Automated Publishing**

For the `publish.yml` workflow to work, you must authorize GitHub Actions on `pub.dev`.

- Go to your package's page on `pub.dev` and click the **Admin** tab.
- Under **Automated publishing**, click **Enable publishing from GitHub Actions**.
- Set the **Repository** to your `username/repository_name`.
- Set the **Tag pattern** to `v{{version}}`.
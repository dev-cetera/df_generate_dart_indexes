[![pub](https://img.shields.io/pub/v/df_generate_dart_indexes.svg)](https://pub.dev/packages/df_generate_dart_indexes)
[![tag](https://img.shields.io/badge/Tag-v0.7.0-purple?logo=github)](https://github.com/dev-cetera/df_generate_dart_indexes/tree/v0.7.0)
[![buymeacoffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/dev_cetera)
[![sponsor](https://img.shields.io/badge/Sponsor-grey?logo=github-sponsors&logoColor=pink)](https://github.com/sponsors/dev-cetera)
[![patreon](https://img.shields.io/badge/Patreon-grey?logo=patreon)](https://www.patreon.com/robelator)
[![discord](https://img.shields.io/badge/Discord-5865F2?logo=discord&logoColor=white)](https://discord.gg/gEQ8y2nfyX)
[![instagram](https://img.shields.io/badge/Instagram-E4405F?logo=instagram&logoColor=white)](https://www.instagram.com/dev_cetera/)
[![license](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE)

---

<!-- BEGIN _README_CONTENT -->

Generates a barrel (`_<folder>.g.dart`) that re-exports every Dart file in a directory.

## Install

```sh
dart pub global activate df_generate_dart_indexes
```

## Use

From inside the folder you want to index, run:

```sh
df_generate_dart_indexes --barrel
```

Files starting with `_`, files inside folders starting with `_`, and `*.g.dart` files are skipped.

A [VS Code extension](https://marketplace.visualstudio.com/items?itemName=Dev-Cetera.dev-cetera-df-support-commands) is also available — right-click a folder and pick `🔹 Generate Dart Barrel File`.

<!-- END _README_CONTENT -->

---

🔍 For more information, refer to the [API reference](https://pub.dev/documentation/df_generate_dart_indexes/).

---

## 💬 Contributing and Discussions

This is an open-source project, and we warmly welcome contributions from everyone, regardless of experience level. Whether you're a seasoned developer or just starting out, contributing to this project is a fantastic way to learn, share your knowledge, and make a meaningful impact on the community.

### ☝️ Ways you can contribute

- **Find us on Discord:** Feel free to ask questions and engage with the community here: https://discord.gg/gEQ8y2nfyX.
- **Share your ideas:** Every perspective matters, and your ideas can spark innovation.
- **Help others:** Engage with other users by offering advice, solutions, or troubleshooting assistance.
- **Report bugs:** Help us identify and fix issues to make the project more robust.
- **Suggest improvements or new features:** Your ideas can help shape the future of the project.
- **Help clarify documentation:** Good documentation is key to accessibility. You can make it easier for others to get started by improving or expanding our documentation.
- **Write articles:** Share your knowledge by writing tutorials, guides, or blog posts about your experiences with the project. It's a great way to contribute and help others learn.

No matter how you choose to contribute, your involvement is greatly appreciated and valued!

### ☕ We drink a lot of coffee...

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here: https://www.buymeacoffee.com/dev_cetera

<a href="https://www.buymeacoffee.com/dev_cetera" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="40"></a>

## LICENSE

This project is released under the [MIT License](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE). See [LICENSE](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE) for more information.

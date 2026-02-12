[![banner](https://github.com/dev-cetera/df_generate_dart_indexes/blob/v0.6.4/doc/assets/banner.png?raw=true)](https://github.com/dev-cetera)

[![pub](https://img.shields.io/pub/v/df_generate_dart_indexes.svg)](https://pub.dev/packages/df_generate_dart_indexes)
[![tag](https://img.shields.io/badge/Tag-v0.6.4-purple?logo=github)](https://github.com/dev-cetera/df_generate_dart_indexes/tree/v0.6.4)
[![buymeacoffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/dev_cetera)
[![sponsor](https://img.shields.io/badge/Sponsor-grey?logo=github-sponsors&logoColor=pink)](https://github.com/sponsors/dev-cetera)
[![patreon](https://img.shields.io/badge/Patreon-grey?logo=patreon)](https://www.patreon.com/robelator)
[![discord](https://img.shields.io/badge/Discord-5865F2?logo=discord&logoColor=white)](https://discord.gg/gEQ8y2nfyX)
[![instagram](https://img.shields.io/badge/Instagram-E4405F?logo=instagram&logoColor=white)](https://www.instagram.com/dev_cetera/)
[![license](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE)

---

<!-- BEGIN _README_CONTENT -->

A tool to generate index/exports files also known as barrel files for all Dart files in a directory.

## How to Use

### With Visual Studio Code

1. Install the extension here: https://marketplace.visualstudio.com/items?itemName=Dev-Cetera.dev-cetera-df-support-commands
2. Right-click on any folder in your project and select `🔹 Generate Dart Barrel File`.
3. Alternatively, right-click a folder and select `"Open in Integrated Terminal"` then run `--barrel` in the terminal.
4. This will generate a barrel file matching the folder’s base name, e.g. `_src.g.dart`.

### Without Visual Studio Code

1. Install this tool by running: `dart pub global activate df_generate_dart_indexes`.
2. In your project, open a terminal at the desired folder, e.g. `cd src`.
3. Run `--barrel` to generate a barrel file matching the folder’s base name, e.g. `_src.g.dart`.

### Note

Files that start with an underscore, files in folders that start with an underscore, and generated files (those with the `.g.dart` extension) will be omitted from the generated barrel file.

### Generated File Example

The file barrel file will look something like this, and is generated from [this default template file](https://github.com/dev-cetera/df_generate_dart_indexes/blob/main/templates/template.dart.md):

```dart
//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED - DO NOT MODIFY BY HAND
// See: https://github.com/dev-cetera/df_generate_dart_indexes
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

export './screens/welcome_screen/widget.dart';
export './screens/home_screen/widget.dart';
export './widgets/my_button.dart';
export './widgets/my_title_text.dart';
```

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

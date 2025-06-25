<a href="https://www.buymeacoffee.com/dev_cetera" target="_blank"><img align="right" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" height="48"></a>
<a href="https://discord.gg/gEQ8y2nfyX" target="_blank"><img align="right" src="https://raw.githubusercontent.com/dev-cetera/resources/refs/heads/main/assets/discord_icon/discord_icon.svg" height="48"></a>

Dart & Flutter Packages by dev-cetera.com & contributors.

[![pub](https://img.shields.io/pub/v/df_generate_dart_indexes.svg)](https://pub.dev/packages/df_generate_dart_indexes)
[![tag](https://img.shields.io/badge/tag-v0.5.17-purple)](https://github.com/dev-cetera/df_generate_dart_indexes/tree/v0.5.17)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE)

---

<!-- BEGIN _README_CONTENT -->

## Summary

A tool to generate index/exports files also known as barrel files for all Dart files in a directory.

## Usage Instructions

1. No need to add this package to your `pubspec.yaml`.
2. Activate it by running: `dart pub global activate df_generate_dart_indexes`.
3. In your project, open a terminal in the desired folder (Tip: In VS Code, right-click a folder and select `"Open in Integrated Terminal"`).
4. Run gen-indexes to create an `_index.g.dart` file at the current location. Alternatively, use `gen-barrel` to generate a barrel file matching the folder’s base name, e.g. `_src.g.dart` or `_widgets.g.dart`.
5. Bonus: You can also generate TypeScript index files by running `gen-indexes-ts`.

### Note:

Files that start with an underscore, files in folders that start with an underscore, and generated files (those with the `.g.dart` extension) will be omitted from the generated barrel file.

### Generated File Example:

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

☝️ Please refer to the [API reference](https://pub.dev/documentation/df_generate_dart_indexes/) for more information.

---

## 💬 Contributing and Discussions

This is an open-source project, and we warmly welcome contributions from everyone, regardless of experience level. Whether you're a seasoned developer or just starting out, contributing to this project is a fantastic way to learn, share your knowledge, and make a meaningful impact on the community.

### ☝️ Ways you can contribute

- **Buy me a coffee:** If you'd like to support the project financially, consider [buying me a coffee](https://www.buymeacoffee.com/dev_cetera). Your support helps cover the costs of development and keeps the project growing.
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

## 🧑‍⚖️ License

This project is released under the [MIT License](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE). See [LICENSE](https://raw.githubusercontent.com/dev-cetera/df_generate_dart_indexes/main/LICENSE) for more information.


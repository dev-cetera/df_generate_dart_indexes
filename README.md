# DF Generate Dart Indexes

Dart & Flutter Packages by DevCetra.com & contributors.

[![Pub Package](https://img.shields.io/pub/v/df_generate_dart_indexes.svg)](https://pub.dev/packages/df_generate_dart_indexes)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/robmllze/df_generate_dart_indexes/main/LICENSE)
[![Buy Me a Coffee](https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee)](https://www.buymeacoffee.com/robmllze)

---

## Summary

A tool to generate index/exports files for all Dart files in a directory.

## Usage Instructions

1. You do not need to add this package to your pubspec.yaml file.
2. Activate the tool by running: `dart pub global activate df_generate_dart_indexes`.
3. Navigate to a folder in your project using the terminal (Tip: If you're using VS Code, you can right-click on a folder and select `"Open in Integrated Terminal"`).
4. Run `dartindexes .` to generate an `_index.g.dart` file at the current location `.`.

### Note:

Files that start with an underscore, files in folders that start with an underscore, and generated files (those with the `.g.dart` extension) will be omitted from `_index.g.dart`.

### Generated File Example:

```dart
//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED - DO NOT MODIFY BY HAND
// See: https://pub.dev/packages/df_generate_dart_indexes
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// --- PUBLIC FILES ---
export 'generate_index_files_for_dart.dart';
export 'run_generate_index_files_for_dart_app.dart';

// --- PRIVATE FILES (EXCLUDED) ---
// export '_utils/_generator_converger.dart';
// export '_utils/_insight_mappers.dart';

// --- GENERATED FILES (EXCLUDED) ---
// export '_index.g.dart';
```

---

## Contributing and Discussions

This is an open-source project, and contributions are welcome from everyone, regardless of experience level. Contributing to projects is a great way to learn, share knowledge, and showcase your skills to the community. Join the discussions to ask questions, report bugs, suggest features, share ideas, or find out how you can contribute.

### Join GitHub Discussions:

💬 https://github.com/robmllze/df_generate_dart_indexes/discussions/

### Join Reddit Discussions:

💬 https://www.reddit.com/r/df_generate_dart_indexes/

### Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

### Donating:

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here:

https://www.buymeacoffee.com/robmllze

---

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/df_generate_dart_indexes/main/LICENSE) for more information.

## Summary

A tool to generate index/exports files also known as barrel files for all Dart files in a directory.

## Usage Instructions

1. No need to add this package to your `pubspec.yaml`.
2. Activate it by running: `dart pub global activate df_generate_dart_indexes`.
3. In your project, open a terminal in the desired folder (Tip: In VS Code, right-click a folder and select `"Open in Integrated Terminal"`).
4. Run `df_generate_dart_indexes` to generate a barrel file matching the folder’s base name, e.g. `_src.g.dart` or `_widgets.g.dart`.
5. Bonus: You can also generate TypeScript index files by running `df_generate_dart_indexes_ts`. This is mainly focused on Dart. Other langauges not yet supported.

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

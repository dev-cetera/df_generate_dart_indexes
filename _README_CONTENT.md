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

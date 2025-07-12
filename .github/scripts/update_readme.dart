//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> args) {
  if (args.length < 3) {
    print('Usage: dart run update_readme.dart <template_path> <package_name> <package_version>');
    exit(1);
  }

  final templatePath = args[0];
  final packageName = args[1];
  final packageVersion = args[2];

  // These paths are relative to where the script is run (the project root).
  final localContentPath = '_README_CONTENT.md';
  final finalReadmePath = 'README.md';

  // --- 1. Load the master template file from the path provided by the CI ---
  final templateFile = File(templatePath);
  if (!templateFile.existsSync()) {
    print('ERROR: Master README template not found at $templatePath');
    exit(1);
  }
  final readmeTemplate = templateFile.readAsStringSync();

  // --- 2. Load the local content file ---
  final localContentFile = File(localContentPath);
  if (!localContentFile.existsSync()) {
    print('INFO: No _README_CONTENT.md found for $packageName. Cannot generate README.');
    // Exit gracefully if there's no content to inject for this package.
    exit(0);
  }
  final localReadmeContent = localContentFile.readAsStringSync();

  // --- 3. Perform all replacements ---
  var finalContent = readmeTemplate.replaceAll('{{{PACKAGE}}}', packageName);
  finalContent = finalContent.replaceAll('{{{VERSION}}}', packageVersion);
  finalContent = finalContent.replaceAll('{{{_README_CONTENT}}}', localReadmeContent);

  // --- 4. Write the new README.md file ---
  final finalReadmeFile = File(finalReadmePath);
  finalReadmeFile.writeAsStringSync(finalContent);

  print('SUCCESS: README.md for $packageName v$packageVersion has been updated.');
}

//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_gen_core/df_gen_core.dart';

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// [STEP 1] Define come constants to hold default argument values:
const _DEFAULT_TEMPLATE_PATH_OR_URL =
    'https://raw.githubusercontent.com/robmllze/df_generate_dart_indexes/main/templates/template.ts.md';
const _OUTPUT_PATH = 'index.ts';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> genIndexesTs(List<String> args) async {
  // [STEP 2] Create an instance of the CliBuilder class to help us manage
  // our CLI application.
  final parser = CliParser(
    title: 'DevCetra.com/df/tools',
    description:
        'A tool for generating index/barrel files for TypeScript. Ignores files that starts with underscores.',
    example: 'gen-indexes-ts -i . -o index.ts',
    params: [
      DefaultFlags.HELP.flag,
      DefaultOptions.INPUT_PATH.option.copyWith(
        defaultsTo: FileSystemUtility.i.currentDir,
      ),
      DefaultOptions.TEMPLATE_PATH_OR_URL.option.copyWith(
        defaultsTo: _DEFAULT_TEMPLATE_PATH_OR_URL,
      ),
    ],
  );

  // [STEP 3] Parse our arguments.
  final (argResults, argParser) = parser.parse(args);

  // [STEP 4] Print help message if the user requests it, then exit.
  final help = argResults.flag(DefaultFlags.HELP.name);
  if (help) {
    _print(
      printCyan,
      parser.getInfo(argParser),
    );
    exit(ExitCodes.SUCCESS.code);
  }

  // [STEP 4] Extract all the arguments we need.
  late final String inputPath;
  late final String templatePathOrUrl;
  try {
    inputPath = argResults.option(DefaultOptions.INPUT_PATH.name)!;
    templatePathOrUrl =
        argResults.option(DefaultOptions.TEMPLATE_PATH_OR_URL.name)!;
  } catch (_) {
    _print(
      printRed,
      'Missing required args! Use --help flag for more information.',
    );
    exit(ExitCodes.FAILURE.code);
  }

  // [STEP 5] Create a stream to get all files ending in .dart but not in
  // .g.dart and do not start with underscores.
  final filePathStream0 = PathExplorer(inputPath).exploreFiles();
  final filePathStream1 = filePathStream0.where((e) {
    final path = p.relative(e.path, from: inputPath);
    return _isAllowedFileName(path);
  });

  final spinner = Spinner();
  spinner.start();
  _print(
    printWhite,
    'Looking for TypeScript files...',
    spinner,
  );

  // [STEP 6] Create a replacement map for the template, to replace
  // placeholders in the template with the actual values. We also want to skip
  // the output file from being added to the exports file.
  final skipPath = p.join(inputPath, _OUTPUT_PATH);
  final exportableFilePaths = await filePathStream1.toList();
  final replacementMap = {
    '___PUBLIC_EXPORTS___': _publicExports(
      inputPath,
      exportableFilePaths.map((e) => e.path).where((e) => e != skipPath),
      (e) => true,
      (e) => 'export * from \'./$e\';',
    ),
  };

  _print(
    printWhite,
    'Reading template at: $templatePathOrUrl...',
    spinner,
  );

  // [STEP 7] Read the template file.
  final result = await MdTemplateUtility.i.readTemplateFromPathOrUrl(
    templatePathOrUrl,
  );
  if (result.isErr) {
    _print(
      printRed,
      'Failed to read template!',
      spinner,
    );
    exit(ExitCodes.FAILURE.code);
  }

  // [STEP 8] Replace the placeholders in the template with the actual values.
  final output = result.unwrap().replaceData(replacementMap);

  _print(
    printWhite,
    'Writing output to $_OUTPUT_PATH...',
    spinner,
  );

  // [STEP 9] Write the output file.
  try {
    await FileSystemUtility.i.writeLocalFile(_OUTPUT_PATH, output);
  } catch (e) {
    _print(
      printRed,
      'Failed to write at: $_OUTPUT_PATH',
      spinner,
    );
    exit(ExitCodes.FAILURE.code);
  }

  // [STEP 10] Print success!
  spinner.stop();
  _print(
    printGreen,
    'Done!',
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void _print(
  void Function(String) print,
  String message, [
  Spinner? spinner,
]) {
  spinner?.stop();
  print('[gen-indexes-ts] $message');
  spinner?.start();
}

String _publicExports(
  String inputPath,
  Iterable<String> filePaths,
  bool Function(String filePath) test,
  String Function(String baseName) statementBuilder,
) {
  final relativeFilePaths =
      filePaths.map((e) => p.relative(e, from: inputPath));
  final exportFilePaths = relativeFilePaths.where((e) => test(e));
  final statements = exportFilePaths.map(statementBuilder);
  return statements.join('\n');
}

bool _isAllowedFileName(String e) {
  return !e.startsWith('_') &&
      !e.contains('${p.separator}_') &&
      !e.endsWith('.g.ts') &&
      e.endsWith('.ts');
}

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

// [STEP 1] Define some constants to hold default argument values:
const _DEFAULT_TEMPLATE_PATH_OR_URL =
    'https://raw.githubusercontent.com/robmllze/df_generate_dart_indexes/main/templates/template.dart.md';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> genIndexes(
  List<String> args, {
  String defaultOutputPath = '_{folder}.g.dart',
}) async {
  // [STEP 2] Create an instance of the CliBuilder class to help us manage
  // our CLI application.
  final parser = CliParser(
    title: 'DevCetra.com/df/tools',
    description:
        'A tool for generating index/barrel files for Dart. Ignores files that starts with underscores.',
    example: 'gen-indexes -i . -o _index.g.dart',
    params: [
      DefaultFlags.HELP.flag.copyWith(
        negatable: true,
      ),
      DefaultOptions.INPUT_PATH.option.copyWith(
        defaultsTo: FileSystemUtility.i.currentScriptDir,
      ),
      DefaultOptions.TEMPLATE_PATH_OR_URL.option.copyWith(
        defaultsTo: _DEFAULT_TEMPLATE_PATH_OR_URL,
      ),
      DefaultOptions.OUTPUT_PATH.option.copyWith(
        defaultsTo: defaultOutputPath,
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

  // [STEP 5] Extract all the arguments we need.
  late final String inputPath;
  late final String templatePathOrUrl;
  String outputFilePath;
  try {
    inputPath = argResults.option(DefaultOptions.INPUT_PATH.name)!;
    templatePathOrUrl = argResults.option(DefaultOptions.TEMPLATE_PATH_OR_URL.name)!;
    outputFilePath = argResults.option(DefaultOptions.OUTPUT_PATH.name)!;
  } catch (_) {
    _print(
      printRed,
      'Missing required args! Use --help flag for more information.',
    );
    exit(ExitCodes.FAILURE.code);
  }

  // [STEP 6] Decide on the output file path.
  outputFilePath = outputFilePath.replaceAll(
    '{folder}',
    PathUtility.i.folderName(
      p.join(
        FileSystemUtility.i.currentScriptDir,
        outputFilePath,
      ),
    ),
  );
  // If the output file path is relative, then make it relative to the current
  // script directory.
  if (p.isRelative(outputFilePath)) {
    outputFilePath = p.join(
      FileSystemUtility.i.currentScriptDir,
      outputFilePath,
    );
  }

  // [STEP 7] Create a stream to get all files ending in .dart but not in
  // .g.dart and do not start with underscores.
  final filePathStream0 = PathExplorer(inputPath).exploreFiles();
  final filePathStream1 = filePathStream0.where((e) => _isAllowedFileName(e.path));

  final spinner = Spinner();
  spinner.start();
  _print(
    printWhite,
    'Looking for Dart files...',
    spinner,
  );

  // [STEP 8] Create a replacement map for the template, to replace
  // placeholders in the template with the actual values. We also want to skip
  // the output file from being added to the exports file.
  final skipPath = p.relative(outputFilePath, from: inputPath);
  final exportableFilePaths = await filePathStream1.toList();
  final replacementMap = {
    '___PUBLIC_EXPORTS___': _publicExports(
      inputPath,
      exportableFilePaths.map((e) => e.path).where((e) => e != skipPath),
      (e) => true,
      (e) => 'export \'./$e\';',
    ),
  };

  _print(
    printWhite,
    'Reading template at: $templatePathOrUrl...',
    spinner,
  );

  // [STEP 9] Read the template file.
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

  // [STEP 10] Replace the placeholders in the template with the actual values.
  final output = result.unwrap().replaceData(replacementMap);

  _print(
    printWhite,
    'Writing output to $outputFilePath...',
    spinner,
  );

  // [STEP 11] Write the output file.
  try {
    await FileSystemUtility.i.writeLocalFile(outputFilePath, output);
  } catch (e) {
    _print(
      printRed,
      'Failed to write at: $outputFilePath',
      spinner,
    );
    exit(ExitCodes.FAILURE.code);
  }

  // [STEP 12] Print success!
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
  print('[gen-indexes] $message');
  spinner?.start();
}

String _publicExports(
  String inputPath,
  Iterable<String> filePaths,
  bool Function(String filePath) test,
  String Function(String baseName) statementBuilder,
) {
  final relativeFilePaths = filePaths.map((e) => p.relative(e, from: inputPath));
  final exportFilePaths = relativeFilePaths.where((e) => test(e));
  final statements = exportFilePaths.map(statementBuilder);
  return statements.join('\n');
}

bool _isAllowedFileName(String e) {
  return !e.startsWith('_') &&
      !e.contains('${p.separator}_') &&
      !e.endsWith('.g.dart') &&
      e.endsWith('.dart');
}

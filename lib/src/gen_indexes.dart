//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_gen_core/df_gen_core.dart';
// ignore: implementation_imports
import 'package:df_config/src/_etc/replace_data.dart';

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> genIndexes(
  List<String> args, {
  required List<String> defaultTemplates,
}) async {
  final parser = CliParser(
    title: 'dev-cetera.com/df/tools',
    description:
        'A tool for generating index/barrel files for Dart. Ignores files that starts with underscores.',
    example: 'gen-indexes -i .',
    params: [
      DefaultFlags.HELP.flag.copyWith(negatable: true),
      DefaultOptions.INPUT_PATH.option.copyWith(
        defaultsTo: FileSystemUtility.i.currentDir,
      ),
      DefaultMultiOptions.TEMPLATES.multiOption.copyWith(
        defaultsTo: defaultTemplates,
      ),
    ],
  );

  // ---------------------------------------------------------------------------

  final (argResults, argParser) = parser.parse(args);

  // ---------------------------------------------------------------------------

  final help = argResults.flag(DefaultFlags.HELP.name);
  if (help) {
    _print(Glog.printCyan, parser.getInfo(argParser));
    exit(ExitCodes.SUCCESS.code);
  }

  // ---------------------------------------------------------------------------

  late final String inputPath;
  late final List<String> templates;
  try {
    inputPath = argResults.option(DefaultOptions.INPUT_PATH.name)!;
    templates = argResults.multiOption(DefaultMultiOptions.TEMPLATES.name);
  } catch (_) {
    _print(
      Glog.printRed,
      'Missing required args! Use --help flag for more information.',
    );
    exit(ExitCodes.FAILURE.code);
  }

  // ---------------------------------------------------------------------------

  final spinner = Spinner();
  spinner.start();

  // ---------------------------------------------------------------------------

  _print(Glog.printWhite, 'Looking for files..');
  final filePathStream0 = PathExplorer(inputPath).exploreFiles();
  final filePathStream1 = filePathStream0.where((e) {
    final path = p.relative(e.path, from: inputPath);
    return _isAllowedFileName(path);
  });
  List<FilePathExplorerFinding> findings;
  try {
    findings = await filePathStream1.toList();
  } catch (e) {
    _print(Glog.printRed, 'Failed to read file tree!', spinner);
    exit(ExitCodes.FAILURE.code);
  }
  if (findings.isEmpty) {
    spinner.stop();
    _print(Glog.printYellow, 'No files found in $inputPath!');
    exit(ExitCodes.SUCCESS.code);
  }

  // ---------------------------------------------------------------------------

  final templateData = <String, String>{};
  for (final template in templates) {
    _print(Glog.printWhite, 'Reading template at: $template...');
    final result = await MdTemplateUtility.i.readTemplateFromPathOrUrl(template).value;

    if (result.isErr()) {
      spinner.stop();
      _print(Glog.printRed, ' Failed to read template!');
      exit(ExitCodes.FAILURE.code);
    }
    templateData[template] = result.unwrap();
  }

  // ---------------------------------------------------------------------------

  _print(Glog.printWhite, 'Generating...', spinner);
  final inputBasename = p.basename(inputPath);
  for (final entry in templateData.entries) {
    final fileName = p
        .basename(entry.key)
        .replaceAll('.md', '')
        .replaceAll('{basename}', inputBasename.replaceFirst(r'^_+', ''));
    final template = entry.value;
    final skipPath = p.join(inputPath, fileName);
    // ignore: invalid_use_of_internal_member
    final data = template.replaceData({
      '___PUBLIC_EXPORTS___': _publicExports(
        inputPath,
        findings.map((e) => e.path).where((e) => e != skipPath),
        (e) => true,
        (e) {
          final unixPath = p.split(e).join('/');
          return 'export \'./$unixPath\';';
        },
      ),
    });

    _print(Glog.printWhite, 'Writing output to $fileName...', spinner);
    try {
      await FileSystemUtility.i.writeLocalFile(fileName, data);
    } catch (e) {
      _print(Glog.printRed, 'Failed to write at: $fileName', spinner);
      exit(ExitCodes.FAILURE.code);
    }
  }

  // ---------------------------------------------------------------------------

  spinner.stop();
  _print(Glog.printGreen, 'Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void _print(void Function(String) print, String message, [Spinner? spinner]) {
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
  final relativeFilePaths = filePaths.map(
    (e) => p.relative(e, from: inputPath),
  );
  final exportFilePaths = relativeFilePaths.where((e) => test(e));
  final statements = exportFilePaths.map(statementBuilder);
  return statements.join('\n');
}

bool _isAllowedFileName(String e) {
  final lc = e.toLowerCase();
  return !lc.startsWith('_') &&
      !lc.contains('${p.separator}_') &&
      !lc.endsWith('.g.dart') &&
      lc.endsWith('.dart');
}

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

import 'dart:io' show Directory;

import 'package:args/args.dart';

import 'package:df_gen_core/df_gen_core.dart' as gen;

import 'generate_index_files_for_dart.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating index files for Dart from directories.
/// The [args] are interpreted and passed to [generateIndexFilesForDart].
Future<void> runGenerateIndexFilesForDartApp(List<String> args) async {
  await gen.runCommandLineApp(
    title: 'Generate Dart Indexes by DevCetra.com',
    description:
        'A tool to generate index/exports files also known as barrel files for all Dart files in a directory.',
    args: args,
    parser: ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Help information.',
      )
      ..addOption(
        'roots',
        abbr: 'r',
        help: 'Root directory paths of source files separated by `&`.',
        defaultsTo: Directory.current.path,
      )
      ..addOption(
        'subs',
        abbr: 's',
        help: 'Sub-directory paths of source files separated by `&`.',
        defaultsTo: '.',
      )
      ..addOption(
        'patterns',
        abbr: 'p',
        help: 'Path patterns for source files separated by `&`.',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'Template file path or URL.',
        defaultsTo:
            'https://raw.githubusercontent.com/robmllze/df_generate_dart_indexes/main/templates/template.dart.md',
      ),
    onResults: (parser, results) {
      return _ArgsChecker(
        rootPaths: results['roots'],
        subPaths: results['subs'],
        pathPatterns: results['patterns'],
        templatePathOrUrl: results['template'] as String?,
      );
    },
    action: (parser, results, args) async {
      await generateIndexFilesForDart(
        templatePathOrUrl: args.templatePathOrUrl!,
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
      );
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ArgsChecker extends gen.ValidArgsChecker {
  //
  //
  //

  final String? templatePathOrUrl;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;

  //
  //
  //

  _ArgsChecker({
    required this.templatePathOrUrl,
    required dynamic rootPaths,
    required dynamic subPaths,
    required dynamic pathPatterns,
  })  : rootPaths = gen.splitArg(rootPaths)?.toSet(),
        subPaths = gen.splitArg(subPaths)?.toSet(),
        pathPatterns = gen.splitArg(pathPatterns)?.toSet();

  //
  //
  //

  @override
  List<dynamic> get args => [
        templatePathOrUrl,
        rootPaths,
        if (subPaths != null) subPaths,
        if (pathPatterns != null) pathPatterns,
      ];
}

//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:convert';

import 'package:df_gen_core/df_gen_core.dart' as gen;
import 'package:df_gen_core/df_gen_core.dart';
import 'package:df_log/df_log.dart';

import '_utils/_generator_converger.dart';
import '_utils/_insight_mappers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Generates index files for Dart from directories.
///
/// This function combines [rootDirPaths] and [subDirPaths], applying
/// [pathPatterns] to filter and determine the directories to search for source
/// files.
///
/// The outputs are generated from templates in [templatesRootDirPaths] and the
/// generated files are placed in the appropriate directories.
Future<void> generateIndexFilesForDart({
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required Set<String> templatesRootDirPaths,
}) async {
  // Notify start.
  debugLogStart('Starting generator. Please wait...');

  // Explore all source paths.
  final sourceFileExporer = gen.PathExplorer(
    dirPathGroups: {
      gen.CombinedPaths(
        rootDirPaths,
        subPaths: subDirPaths,
        pathPatterns: pathPatterns,
      ),
    },
  );
  final sourceFileExplorerResults = await sourceFileExporer.explore();

  final template = await loadFileFromGitHub(
    username: 'robmllze',
    repo: 'df_generate_dart_indexes',
    filePath: 'templates/template.dart.md',
  );

  printYellow(template);

  // Extract insights from the dir path results.
  final dirInsights =
      sourceFileExplorerResults.rootDirPathResults.map((e) => gen.DirInsight(dir: e));

  // Converge what was gathered to generate the output.
  await generatorConverger.converge(
    dirInsights,
    [template],
    insightMappers,
  );

  // ---------------------------------------------------------------------------

  // Notify end.
  debugLogStop('Done!');
}

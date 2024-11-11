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

import 'package:df_gen_core/df_gen_core.dart' as gen;
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
  required String templatePathOrUrl,
}) async {
  // Notify start.
  printBlue('Starting generator. Please wait...');
  // Explore all source paths.
  final sourceFileExporer = gen.PathExplorer(
    dirPathGroups: {
      gen.MatchedPathPowerset(
        rootDirPaths,
        subPaths: subDirPaths,
        pathPatterns: pathPatterns,
      ),
    },
  );
  final sourceFileExplorerResults = await sourceFileExporer.explore();
  final template = (await gen.FileSystemUtility.i.readFileFromPathOrUrl(templatePathOrUrl))!;

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
  printPurple('Done!');
}

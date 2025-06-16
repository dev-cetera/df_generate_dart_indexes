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

import 'dart:io';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> args) {
  final version = args.isNotEmpty ? args[0] : '0.1.0';
  final comitMesssage = args.length > 1 ? args[1].replaceFirst('+', '') : '';
  final changelogPath = 'CHANGELOG.md';
  final file = File(changelogPath);
  if (!file.existsSync()) {
    print('$changelogPath does not exist.');
    exit(1);
  }
  var contents = file.readAsStringSync();
  contents = contents.replaceAll('# Changelog', '').trim();
  final sections = extractSections(contents);
  final versionExist = sections.where((e) => e.version == version).isNotEmpty;
  if (versionExist) {
    sections.where((e) => e.version == version).forEach((e) {
      e.addUpdate(comitMesssage);
    });
  } else {
    sections.add(
      _VersionSection(
        version: version,
        releasedAt: DateTime.now().toUtc(),
        updates: {comitMesssage},
      ),
    );
  }
  contents = '# Changelog\n\n${(sections.toList()..sort((a, b) {
      return compareVersions(b.version, a.version);
    })).map((e) => e.toString()).join('\n')}';

  file.writeAsStringSync(contents);
  print('Changelog updated with version $version.');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Set<_VersionSection> extractSections(String contents) {
  final headerPattern = RegExp(r'## \[\d+\.\d+\.\d+(\+\d+)?\]');
  final allVersionMatches = headerPattern.allMatches(contents).toList();
  final results = <_VersionSection>{};
  for (var i = 0; i < allVersionMatches.length; i++) {
    final start = allVersionMatches[i].end;
    final end = i + 1 < allVersionMatches.length ? allVersionMatches[i + 1].start : contents.length;
    final sectionContents = contents.substring(start, end).trim();
    final lines = sectionContents.split('\n').where((line) => line.isNotEmpty).toList();
    final version =
        allVersionMatches[i].group(0)!.substring(4, allVersionMatches[i].group(0)!.length - 1);
    var releasedAt = DateTime.now().toUtc();
    final updates = <String>{};
    final old = lines
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.startsWith('-') ? e.substring(1) : e)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    for (var line in old) {
      if (line.contains('Released @')) {
        releasedAt = parseReleaseDate(line);
      } else {
        updates.add(line);
      }
    }
    results.add(_VersionSection(
      version: version,
      releasedAt: releasedAt,
      updates: updates,
    ));
  }

  return results;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _VersionSection {
  //
  //
  //

  String version;
  DateTime releasedAt;
  Set<String> updates;

  //
  //
  //

  _VersionSection({
    required this.version,
    required this.releasedAt,
    Set<String>? updates,
  }) : this.updates = updates ?? {};

  //
  //
  //

  void addUpdate(String update) {
    updates.add(update);
    releasedAt = DateTime.now().toUtc();
  }

  //
  //
  //

  @override
  String toString() {
    final updatesString = updates.map((update) => '- $update').join('\n');
    return '## [$version]\n\n- Released @ ${releasedAt.month}/${releasedAt.year} (UTC)\n$updatesString\n';
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

int compareVersions(String version1, String version2) {
  List<int> parseVersion(String version) {
    // Split by the '+' first to handle the build number
    final parts = version.split('+');
    final versionParts = parts[0].split('.').map(int.tryParse).map((e) => e ?? 0).toList();
    // Add the build number as the last part (if it exists)
    if (parts.length > 1) {
      versionParts.add(int.tryParse(parts[1]) ?? 0);
    }
    return versionParts;
  }

  final v1 = parseVersion(version1);
  final v2 = parseVersion(version2);
  final maxLength = v1.length > v2.length ? v1.length : v2.length;
  for (var i = 0; i < maxLength; i++) {
    final part1 = i < v1.length ? v1[i] : 0;
    final part2 = i < v2.length ? v2[i] : 0;
    if (part1 > part2) return 1;
    if (part1 < part2) return -1;
  }
  return 0;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

DateTime parseReleaseDate(String line) {
  if (line.contains('Released @')) {
    final temp = line.split('Released @').last.trim().replaceAll(' (UTC)', '');
    final parts = temp.split('/');
    if (parts.length == 2) {
      final month = int.tryParse(parts[0]) ?? 1;
      final year = int.tryParse(parts[1]) ?? DateTime.now().year;
      return DateTime.utc(year, month);
    }
  }

  return DateTime.now().toUtc();
}

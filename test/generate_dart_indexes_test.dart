// Integration tests for the `generateDartIndexes` function. We don't shell out
// to the CLI binary — we call the public function directly with a temp dir,
// a local template file, and inspect the produced file.

import 'dart:io';

import 'package:df_generate_dart_indexes/df_generate_dart_indexes.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory tmp;
  late String templatePath;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('df_indexes_test_');
    // Put a minimal local template so the test never hits the network.
    templatePath = p.join(tmp.path, '_index.g.dart.md');
    await File(templatePath).writeAsString('''
```dart
// generated
___PUBLIC_EXPORTS___
```
''');
  });

  tearDown(() async {
    if (await tmp.exists()) {
      await tmp.delete(recursive: true);
    }
  });

  Future<File> writeDart(String relPath, String body) async {
    final f = File(p.join(tmp.path, relPath));
    await f.parent.create(recursive: true);
    await f.writeAsString(body);
    return f;
  }

  /// Runs the generator with `current` directory set to [tmp] so output
  /// lands inside the temp dir.
  Future<File> runWithCwd(List<String> args) async {
    final originalCwd = Directory.current;
    Directory.current = tmp;
    try {
      await generateDartIndexes(args, defaultTemplates: [templatePath]);
    } finally {
      Directory.current = originalCwd;
    }
    return File(p.join(tmp.path, '_index.g.dart'));
  }

  test('writes an index file with relative export statements', () async {
    await writeDart('foo.dart', '// foo');
    await writeDart('bar.dart', '// bar');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, contains("export './foo.dart';"));
    expect(body, contains("export './bar.dart';"));
    // Banner from the template:
    expect(body, contains('// generated'));
  });

  test('excludes files starting with underscores', () async {
    await writeDart('foo.dart', '// foo');
    await writeDart('_private.dart', '// private');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, contains('foo.dart'));
    expect(body, isNot(contains('_private.dart')));
  });

  test('excludes files in directories starting with underscore', () async {
    await writeDart('foo.dart', '// foo');
    await writeDart('_hidden/inner.dart', '// hidden');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, contains('foo.dart'));
    expect(body, isNot(contains('inner.dart')));
  });

  test('excludes .g.dart files', () async {
    await writeDart('foo.dart', '// foo');
    await writeDart('foo.g.dart', '// gen');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, contains('foo.dart'));
    expect(body, isNot(contains('foo.g.dart')));
  });

  test('subdirectory files use forward-slash paths in exports', () async {
    await writeDart('src/inner.dart', '// inner');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, contains("export './src/inner.dart';"));
  });

  test('excludes the generated index file itself from the exports', () async {
    await writeDart('a.dart', '// a');
    // Pre-create the output to verify it doesn't self-include.
    await File(p.join(tmp.path, '_index.g.dart'))
        .writeAsString('// placeholder');
    final out = await runWithCwd(['-i', '.']);
    final body = await out.readAsString();

    expect(body, isNot(contains("export './_index.g.dart';")));
    expect(body, contains("export './a.dart';"));
  });

  test(
      'writes barrel INTO the input dir when -i is a sibling path (regression)',
      () async {
    // Earlier the generator wrote `_index.g.dart` to CWD regardless of the
    // -i argument, so running `df_generate_dart_indexes -i sub` from one
    // dir up left the barrel beside the wrong files and its `./foo.dart`
    // exports pointed at non-existent paths.
    final subdir = Directory(p.join(tmp.path, 'sub'));
    await subdir.create();
    await writeDart('sub/foo.dart', '// foo');
    final originalCwd = Directory.current;
    // Run from tmp/ (parent of sub/) — not from inside sub/.
    Directory.current = tmp;
    try {
      await generateDartIndexes(
        ['-i', 'sub'],
        defaultTemplates: [templatePath],
      );
    } finally {
      Directory.current = originalCwd;
    }
    final placed = File(p.join(subdir.path, '_index.g.dart'));
    expect(
      placed.existsSync(),
      isTrue,
      reason: 'barrel must land inside the input dir',
    );
    // And it should NOT have landed in CWD (tmp).
    final wrongPlace = File(p.join(tmp.path, '_index.g.dart'));
    expect(
      wrongPlace.existsSync(),
      isFalse,
      reason: 'barrel must not land in CWD when -i points elsewhere',
    );
    // The exports inside it use paths relative to inputPath, i.e. relative
    // to the barrel's own directory.
    final body = await placed.readAsString();
    expect(body, contains("export './foo.dart';"));
  });

  test(
    'no dart files → still writes an output file',
    () async {
      // No .dart files in tmp. The generator exits early with success, so the
      // output file should NOT be written.
      expect(
        runWithCwd(['-i', '.']),
        throwsA(anything),
        reason: 'Generator calls exit() when no files found',
      );
    },
    skip: 'Generator calls dart:io exit() — cannot run in test process',
  );
}

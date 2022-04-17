import 'dart:io';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

const errorCode = 2;
const successCode = 0;

void main() {
  group('cli.svgtoavd', () {
    test(
      'exits with error and prints InvalidInputException message '
      'when there is no input',
      () async {
        final process =
            await TestProcess.start('dart', ['run', './bin/svgtoavd.dart']);

        await expectLater(
          process.stderr,
          emitsThrough('InvalidInputException: Invalid input.'),
        );
        await process.shouldExit(errorCode);
      },
    );

    test(
      'exits with error and prints FileParsingException message '
      'when input file in invalid',
      () async {
        final process = await TestProcess.start(
          'dart',
          ['run', './bin/svgtoavd.dart', './test/fixture/svg_file'],
        );

        await expectLater(
          process.stderr,
          emitsThrough(
            'FileParsingException: Failed to parse "./test/fixture/svg_file" '
            'with message: Cannot open file',
          ),
        );
        await process.shouldExit(errorCode);
      },
    );

    test(
      'prints converted file to console when valid file and no output argument',
      () async {
        final process = await TestProcess.start(
          'dart',
          ['run', './bin/svgtoavd.dart', './test/fixture/svg_file.svg'],
        );

        final result = await process.stdout.next;

        expect(result.startsWith('<vector'), true);
        await process.shouldExit(successCode);
      },
    );

    test(
      'prints converted file to console when piping',
      () async {
        final file = await File('./test/fixture/svg_file.svg').readAsString();

        final process = await TestProcess.start(
          'dart',
          ['run', './bin/svgtoavd.dart'],
        );

        process.stdin.writeln(file);
        await process.stdin.close();

        final result = await process.stdout.next;

        expect(result.startsWith('<vector'), true);
        await process.shouldExit(successCode);
      },
    );
  });
}

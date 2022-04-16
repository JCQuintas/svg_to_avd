import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

const stdoutSkip = 9;
const errorCode = 2;
const successCode = 0;

void main() {
  Future<String> getStderrMessage(TestProcess process) async {
    await process.stderr.skip(stdoutSkip);
    return process.stderr.next;
  }

  group('cli.svgtoavd', () {
    test(
      'exits with error and prints InvalidInputException message '
      'when there is no input',
      () async {
        final process =
            await TestProcess.start('dart', ['run', './bin/svgtoavd.dart']);

        final errorMessage = await getStderrMessage(process);

        expect(await process.exitCode, errorCode);
        expect(errorMessage, 'InvalidInputException: Invalid input.');
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

        final errorMessage = await getStderrMessage(process);

        expect(await process.exitCode, errorCode);
        expect(
          errorMessage,
          'FileParsingException: Failed to parse "./test/fixture/svg_file" '
          'with message: Cannot open file',
        );
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

        expect(await process.exitCode, successCode);
        expect(result.startsWith('<vector'), true);
      },
    );
  });
}

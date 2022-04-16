part of '../svgtoavd.dart';

Future<void> inputToAvd(ArgResults argResults) async {
  final buffer = StringBuffer();
  if (argResults.rest.isEmpty) {
    await _stdinToBuffer(buffer);
  } else {
    await _fileToBuffer(buffer, argResults.rest.first);
  }

  if (buffer.isEmpty) {
    throw InvalidInputException();
  }

  final result = SvgToAvd.fromString(buffer.toString()).toPrettyXmlString();
  if (argResults.wasParsed(output)) {
    await File(argResults[output] as String).writeAsString(result);
  } else {
    stdout.writeln(result);
  }
}

Future<void> _stdinToBuffer(StringBuffer buffer) async {
  final subscriber = stdin.transform(utf8.decoder).listen(buffer.write);

  return Future.delayed(
    const Duration(milliseconds: 100),
    () {
      if (buffer.isEmpty) subscriber.cancel();
    },
  );
}

Future<void> _fileToBuffer(StringBuffer buffer, String input) async {
  try {
    final file = await File(input).readAsString();
    buffer.write(file);
  } on FileSystemException catch (e) {
    throw FileParsingException(e.message, e.path);
  } catch (e) {
    rethrow;
  }
}

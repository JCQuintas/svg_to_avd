#! /usr/bin/env dart
/* MIT License

Copyright (c) 2022 Jose C Quintas Jr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:svg_to_avd/svg_to_avd.dart';

part 'parts/file_parsing_exception.dart';
part 'parts/invalid_input_exception.dart';

part 'parts/get_usage_help.dart';
part 'parts/input_to_avd.dart';

const help = 'help';
const output = 'output';

final parser = ArgParser()
  ..allowTrailingOptions
  ..addFlag(
    help,
    negatable: false,
    abbr: 'h',
  )
  ..addOption(
    output,
    abbr: 'o',
    help: 'The XML file to be created. Prints to console if not set.',
  );

Future<void> main(List<String> arguments) async {
  exitCode = 0;
  final usageHelp = _getUsageHelp(parser);
  try {
    final argResults = parser.parse(arguments);

    if (argResults.wasParsed(help)) {
      stdout
        ..write(usageHelp)
        ..writeln();
      return;
    }

    await inputToAvd(argResults);
  } catch (e) {
    exitCode = 2;
    stderr
      ..writeln(usageHelp)
      ..writeln(e.toString())
      ..writeln();
  }
}

part of '../svgtoavd.dart';

StringBuffer _getUsageHelp(ArgParser parser) {
  return StringBuffer()
    ..writeln()
    ..writeln('A command-line to transform SVGs into Android Vector Drawable')
    ..writeln()
    ..writeln('Usage:          svgtoavd [file]')
    ..writeln('Piping:         cat [file] | svgtoavd')
    ..writeln()
    ..writeln(parser.usage);
}

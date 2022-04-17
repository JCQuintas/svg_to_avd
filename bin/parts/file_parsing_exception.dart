part of '../svgtoavd.dart';

class FileParsingException extends SvgToAvdException {
  FileParsingException(String message, String? path)
      : super('Failed to parse "$path" with message: $message');
}

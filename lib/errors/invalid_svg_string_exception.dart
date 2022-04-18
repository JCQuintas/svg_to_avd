import 'package:svg_to_avd/errors/svg_to_avd_exception.dart';

/// Error thrown when input is not a valid svg.
class InvalidSvgStringException extends SvgToAvdException {
  /// Error thrown when input is not a valid svg.
  InvalidSvgStringException()
      : super('Argument `svgString` is not a valid SVG formatted XML.');
}

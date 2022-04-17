import 'package:svg_to_avd/errors/svg_to_avd_exception.dart';

class InvalidSvgStringException extends SvgToAvdException {
  InvalidSvgStringException()
      : super('Argument `svgString` is not a valid SVG formatted XML.');
}

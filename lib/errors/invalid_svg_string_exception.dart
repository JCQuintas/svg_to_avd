import 'package:svg_to_avd/errors/svg_to_vd_exception.dart';

class InvalidSvgStringException extends SvgToVdException {
  InvalidSvgStringException()
      : super('Argument `svgString` is not a valid SVG formatted XML.');
}

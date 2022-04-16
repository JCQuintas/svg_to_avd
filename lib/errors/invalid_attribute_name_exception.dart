import 'package:svg_to_avd/errors/svg_to_avd_exception.dart';

class InvalidAttributeNameException extends SvgToAvdException {
  InvalidAttributeNameException(String attributeName)
      : super(
          'Attribute name `$attributeName` does not have a '
          'corresponding name in Android Vector Drawable conversion table.',
        );
}

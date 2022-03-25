import 'package:svg_to_vector_drawable/errors/svg_to_vd_exception.dart';

class InvalidAttributeNameException extends SvgToVdException {
  InvalidAttributeNameException(String attributeName)
      : super(
          'Attribute name `$attributeName` does not have a '
          'corresponding name in Android Vector Drawable conversion table.',
        );
}

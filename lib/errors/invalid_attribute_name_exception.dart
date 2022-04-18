import 'package:svg_to_avd/errors/svg_to_avd_exception.dart';

/// Error thrown when trying to convert an attribute that we either don't
/// currently support or has no counterpart in avd.
class InvalidAttributeNameException extends SvgToAvdException {
  /// Error thrown when trying to convert an attribute that we either don't
  /// currently support or has no counterpart in avd.
  InvalidAttributeNameException(String attributeName)
      : super(
          'Attribute name `$attributeName` does not have a '
          'corresponding name in Android Vector Drawable conversion table.',
        );
}

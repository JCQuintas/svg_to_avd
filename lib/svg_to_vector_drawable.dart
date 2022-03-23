import 'package:svg_to_vector_drawable/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_vector_drawable/replace_use_tags.dart';
import 'package:xml/xml.dart';

/// Converts the [svgString] into a Vector Drawable.
String svgToVectorDrawable(String svgString) {
  final document = XmlDocument.parse(svgString);

  final globalSvg = document.getElement('svg');

  if (globalSvg == null) throw InvalidSvgStringException();

  replaceUseTags(globalSvg);

  // return
  return globalSvg.toXmlString(pretty: true);
}

import 'package:svg_to_vector_drawable/replace_use_tags.dart';
import 'package:xml/xml.dart';

/// Converts the [xmlString] into a Vector Drawable.
String svgToVectorDrawable(String xmlString) {
  final document = XmlDocument.parse(xmlString);

  final globalSvg = document.getElement('svg');

  if (globalSvg == null) return '';

  replaceUseTags(globalSvg);

  return globalSvg.toXmlString(pretty: true);
}

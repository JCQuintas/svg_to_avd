import 'package:svg_to_avd/attribute_converter.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:svg_to_avd/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_avd/path_converter.dart';
import 'package:svg_to_avd/replace_use_tags.dart';
import 'package:svg_to_avd/root_element_converter.dart';
import 'package:svg_to_avd/transform_converter.dart';
import 'package:xml/xml.dart';

/// Converts the [svgString] into a Vector Drawable.
String svgToAvd(String svgString) {
  final document = XmlDocument.parse(svgString);

  final globalSvg = document.getElement('svg');

  if (globalSvg == null) throw InvalidSvgStringException();

  replaceUseTags(globalSvg);

  for (final element in globalSvg.descendantElements) {
    final pathElement = PathConverter.fromElement(element);

    final convertedAttributes =
        AttributeConverter.fromElement(pathElement ?? element);

    if (element.name.local != ElementName.g) {
      element.replace(convertedAttributes);
    }
  }

  for (final element in globalSvg.descendantElements) {
    final transformElement = TransformConverter.fromElement(element);
    if (transformElement != null) {
      element.replace(transformElement);
    }
  }

  final vectorRoot = RootElementConverter.fromElement(globalSvg);

  // return
  return vectorRoot.toXmlString(pretty: true);
}

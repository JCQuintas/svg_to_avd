library svg_to_avd;

import 'package:svg_to_avd/attribute_converter.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:svg_to_avd/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_avd/path_converter.dart';
import 'package:svg_to_avd/replace_use_tags.dart';
import 'package:svg_to_avd/root_element_converter.dart';
import 'package:svg_to_avd/transform_converter.dart';
import 'package:xml/xml.dart';

/// The SvgToAvg class is an extension of [XmlDocument].
/// It contains a single new method called [toPrettyXmlString] to simplify SVG
/// writing simple SVG strings.
class SvgToAvd extends XmlDocument {
  SvgToAvd._(XmlElement xmlElement) : super([xmlElement]);

  /// Parses the [svgString] into a valid Android Vector Drawable.
  factory SvgToAvd.fromString(String svgString) =>
      SvgToAvd._(_svgToAvd(svgString));

  /// Returns a [String] based on the XmlDocument.
  /// This is a simple wrapper around [toXmlString].
  ///
  /// ```dart
  /// // same as
  /// XmlDocument.toXmlString(pretty: true);
  /// ```
  String toPrettyXmlString() => toXmlString(pretty: true);
}

/// Runs the transformers in the correct order to build the XmlDocument.
XmlElement _svgToAvd(String svgString) {
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

  return RootElementConverter.fromElement(globalSvg);
}

import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:xml/xml.dart';

class AttributeConverter {
  static List<XmlAttribute> fromAttributes(List<XmlAttribute> attributes) {
    final element = XmlElement(
      XmlName('svg-to-avd:temporary-container'),
      attributes.map((child) => child.copy()),
    );
    return <XmlAttribute>[
      ..._getOpacityAttributes(element),
      ..._setDefaultFillAttribute(element),
      ..._getFillRuleAttribute(element),
      ..._getStrokeAttribute(element),
      ..._renameUnconvertedAttributes(element),
    ];
  }

  static XmlElement fromElement(XmlElement element) {
    final temporaryElement = XmlElement(
      XmlName('svg-to-avd:temporary-container'),
      element.attributes.map((child) => child.copy()),
    );

    final groupParents =
        element.ancestorElements.where((e) => e.name.local == ElementName.g);

    for (final parent in groupParents) {
      for (final attribute in parent.attributes) {
        if (temporaryElement.getAttribute(attribute.name.local) == null) {
          temporaryElement.setAttribute(attribute.name.local, attribute.value);
        }
      }
    }

    final newAttributes = fromAttributes(temporaryElement.attributes);

    final clone = XmlElement(
      element.name.copy(),
      newAttributes,
      element.children.map((child) => child.copy()),
      element.isSelfClosing,
    );

    final transform = element.getAttributeNode(AttributeName.transform);
    if (transform != null) {
      return XmlElement(
        XmlName(ElementName.g),
        [transform.copy()],
        [clone],
      );
    }

    return clone;
  }
}

// Parse opacity into its various possible forms.
// If stroke or fill opacity exists, then multiply by opacity.
List<XmlAttribute> _getOpacityAttributes(XmlElement element) {
  final newAttributes = <XmlAttribute>[];

  final opacity = element.getAttribute(AttributeName.opacity);
  final fillOpacity = element.getAttribute(AttributeName.fillOpacity);
  final strokeOpacity = element.getAttribute(AttributeName.strokeOpacity);
  if (opacity != null || fillOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.androidFillAlpha),
        _multiply(opacity, fillOpacity),
      ),
    );
  }
  if (opacity != null || strokeOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.androidStrokeAlpha),
        _multiply(opacity, strokeOpacity),
      ),
    );
  }

  return newAttributes;
}

// Set a default fill value if none is present.
List<XmlAttribute> _setDefaultFillAttribute(XmlElement element) {
  return [
    XmlAttribute(
      XmlName(AttributeName.androidFillColor),
      element.getAttribute(AttributeName.fill) ?? '#000000',
    ),
  ];
}

List<XmlAttribute> _getFillRuleAttribute(XmlElement element) {
  final fillRule = element.getAttribute(AttributeName.fillRule)?.toLowerCase();
  return [
    if (fillRule != null)
      XmlAttribute(
        XmlName(AttributeName.androidFillType),
        fillRule == 'evenOdd'.toLowerCase() ? 'evenOdd' : 'nonZero',
      ),
  ];
}

// Handle default stroke width when required.
List<XmlAttribute> _getStrokeAttribute(XmlElement element) {
  final needsStrokeWidth = [
    AttributeName.opacity,
    AttributeName.stroke,
    AttributeName.strokeOpacity,
    AttributeName.strokeLineJoin,
    AttributeName.strokeMiterLimit,
    AttributeName.strokeLineCap,
  ].any((attribute) => element.getAttribute(attribute) != null);
  final strokeWidth = element.getAttribute(AttributeName.strokeWidth);

  return [
    if (needsStrokeWidth || strokeWidth != null)
      XmlAttribute(
        XmlName(AttributeName.androidStrokeWidth),
        strokeWidth ?? '1',
      ),
  ];
}

// Rename all other unconverted attributes.
List<XmlAttribute> _renameUnconvertedAttributes(XmlElement element) {
  final newAttributes = <XmlAttribute>[];

  final unconvertedAttributes = [
    AttributeName.stroke,
    AttributeName.strokeLineJoin,
    AttributeName.strokeMiterLimit,
    AttributeName.strokeLineCap,
    AttributeName.d,
  ];
  for (final attributeName in unconvertedAttributes) {
    final currentAttribute = element.getAttribute(attributeName);

    if (currentAttribute != null) {
      newAttributes.add(
        XmlAttribute(
          XmlName(AttributeName.toAndroid(attributeName)),
          currentAttribute,
        ),
      );
    }
  }

  return newAttributes;
}

String _multiply(dynamic v1, dynamic v2) =>
    ((double.tryParse(v1.toString()) ?? 1) *
            (double.tryParse(v2.toString()) ?? 1))
        .toString();

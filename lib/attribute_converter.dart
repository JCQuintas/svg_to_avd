import 'package:svg_to_vector_drawable/attribute_name.dart';
import 'package:svg_to_vector_drawable/transform_converter.dart';
import 'package:xml/xml.dart';

String multiply(dynamic v1, dynamic v2) =>
    ((double.tryParse(v1.toString()) ?? 1) *
            (double.tryParse(v2.toString()) ?? 1))
        .toString();

XmlElement attributeConverter(XmlElement element) {
  final newAttributes = <XmlAttribute>[];

  // Parse opacity into its various possible forms
  // If stroke or fill opacity exists, then multiply by opacity
  final opacity = element.getAttribute(AttributeName.opacity);
  final fillOpacity = element.getAttribute(AttributeName.fillOpacity);
  final strokeOpacity = element.getAttribute(AttributeName.strokeOpacity);
  if (opacity != null || fillOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.toAndroid(AttributeName.fillOpacity)),
        multiply(opacity, fillOpacity),
      ),
    );
  }
  if (opacity != null || strokeOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.toAndroid(AttributeName.strokeOpacity)),
        multiply(opacity, strokeOpacity),
      ),
    );
  }

  // Set a default fill value if none is present
  newAttributes.add(
    XmlAttribute(
      XmlName(AttributeName.toAndroid(AttributeName.fill)),
      element.getAttribute(AttributeName.fill) ?? '#000000',
    ),
  );

  // Handle fill-rule
  final fillRule = element.getAttribute(AttributeName.fillRule)?.toLowerCase();
  if (fillRule != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.toAndroid(AttributeName.fillRule)),
        fillRule == 'evenOdd'.toLowerCase() ? 'evenOdd' : 'nonZero',
      ),
    );
  }

  // Handle default stroke width when required
  final needsStrokeWidth = [
    AttributeName.opacity,
    AttributeName.stroke,
    AttributeName.strokeOpacity,
    AttributeName.strokeLineJoin,
    AttributeName.strokeMiterLimit,
    AttributeName.strokeLineCap,
  ].any((attribute) => element.getAttribute(attribute) != null);
  final strokeWidth = element.getAttribute(AttributeName.strokeWidth);
  if (needsStrokeWidth || strokeWidth != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(AttributeName.toAndroid(AttributeName.strokeWidth)),
        strokeWidth ?? '1',
      ),
    );
  }

  // Rename all other unconverted attributes
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

  final clone = XmlElement(
    element.name.copy(),
    newAttributes,
    element.children.map((child) => child.copy()),
    element.isSelfClosing,
  );

  final transform = element.getAttribute(AttributeName.transform);
  if (transform != null) {
    return XmlElement(
      XmlName('group'),
      TransformConverter.fromString(transform),
      [clone],
    );
  }

  return clone;
}

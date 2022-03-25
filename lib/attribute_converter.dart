import 'package:xml/xml.dart';

String multiply(dynamic v1, dynamic v2) =>
    ((double.tryParse(v1.toString()) ?? 1) *
            (double.tryParse(v2.toString()) ?? 1))
        .toString();

String android(String key) => 'android:$key';

const _opacity = 'opacity';
const _fillOpacity = 'fill-opacity';
const _strokeOpacity = 'stroke-opacity';
const _fill = 'fill';
const _fillRule = 'fill-rule';
const _stroke = 'stroke';
const _strokeWidth = 'stroke-width';
const _strokeLineJoin = 'stroke-linejoin';
const _strokeMiterLimit = 'stroke-miterlimit';
const _strokeLineCap = 'stroke-linecap';
const _d = 'd';

final convertMap = {
  _fill: android('fillColor'),
  _fillOpacity: android('fillAlpha'),
  _fillRule: android('fillType'),
  _stroke: android('strokeColor'),
  _strokeOpacity: android('strokeAlpha'),
  _strokeWidth: android('strokeWidth'),
  _strokeLineJoin: android('strokeLineJoin'),
  _strokeMiterLimit: android('strokeMiterLimit'),
  _strokeLineCap: android('strokeLineCap'),
  _d: android('pathData'),
};

XmlElement attributeConverter(XmlElement element) {
  final newAttributes = <XmlAttribute>[];

  // Parse opacity into its various possible forms
  // If stroke or fill opacity exists, then multiply by opacity
  final opacity = element.getAttribute(_opacity);
  final fillOpacity = element.getAttribute(_fillOpacity);
  final strokeOpacity = element.getAttribute(_strokeOpacity);
  if (opacity != null || fillOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(convertMap[_fillOpacity]!),
        multiply(opacity, fillOpacity),
      ),
    );
  }
  if (opacity != null || strokeOpacity != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(convertMap[_strokeOpacity]!),
        multiply(opacity, strokeOpacity),
      ),
    );
  }

  // Set a default fill value if none is present
  newAttributes.add(
    XmlAttribute(
      XmlName(convertMap[_fill]!),
      element.getAttribute(_fill) ?? '#000000',
    ),
  );

  // Handle fill-rule
  final fillRule = element.getAttribute(_fillRule)?.toLowerCase();
  if (fillRule != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(convertMap[_fillRule]!),
        fillRule == 'evenOdd'.toLowerCase() ? 'evenOdd' : 'nonZero',
      ),
    );
  }

  // Handle default stroke width when required
  final needsStrokeWidth = [
    _opacity,
    _stroke,
    _strokeOpacity,
    _strokeLineJoin,
    _strokeMiterLimit,
    _strokeLineCap,
  ].any((attribute) => element.getAttribute(attribute) != null);
  final strokeWidth = element.getAttribute(_strokeWidth);
  if (needsStrokeWidth || strokeWidth != null) {
    newAttributes.add(
      XmlAttribute(
        XmlName(convertMap[_strokeWidth]!),
        strokeWidth ?? '1',
      ),
    );
  }

  // Rename all other unconverted attributes
  final unconvertedAttributes = [
    _stroke,
    _strokeLineJoin,
    _strokeMiterLimit,
    _strokeLineCap,
    _d,
  ];
  for (final attributeName in unconvertedAttributes) {
    final currentAttribute = element.getAttribute(attributeName);

    if (currentAttribute != null) {
      newAttributes.add(
        XmlAttribute(
          XmlName(convertMap[attributeName]!),
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

  return clone;
}

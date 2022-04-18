import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/dimension_to_pixel.dart';
import 'package:xml/xml.dart';

/// Responsible for converting the `svg` element.
class RootElementConverter {
  /// Converts an `svg` element into a `vector` element. Translating all the
  /// necessary attributes.
  static XmlElement fromElement(XmlElement element) {
    final newElement = XmlElement(
      XmlName('vector'),
      [],
      element.children.map((child) => child.copy()),
      element.isSelfClosing,
    )..setAttribute(
        'xmlns:android',
        'http://schemas.android.com/apk/res/android',
      );

    final dimensions = _SvgDimension.parse(element);

    newElement
      ..setAttribute(
        AttributeName.androidWidth,
        '${dimensions.width.toStringAsFixed(0)}dp',
      )
      ..setAttribute(
        AttributeName.androidHeight,
        '${dimensions.height.toStringAsFixed(0)}dp',
      )
      ..setAttribute(
        AttributeName.androidViewportWidth,
        dimensions.width.toString(),
      )
      ..setAttribute(
        AttributeName.androidViewportHeight,
        dimensions.height.toString(),
      );

    return newElement;
  }
}

class _SvgDimension {
  _SvgDimension._({required this.height, required this.width});
  factory _SvgDimension.parse(XmlElement element) {
    final widthAttribute = element.getAttribute('width');
    final heightAttribute = element.getAttribute('height');
    final viewBoxAttribute = element.getAttribute('viewBox');

    if (viewBoxAttribute != null) {
      final viewBoxAttributeParts =
          viewBoxAttribute.split(RegExp(r'[,\s]+')).map(double.parse).toList();

      return _SvgDimension._(
        width: viewBoxAttributeParts[2],
        height: viewBoxAttributeParts[3],
      );
    }

    if (widthAttribute != null && heightAttribute != null) {
      return _SvgDimension._(
        height: dimensionToPixel(heightAttribute),
        width: dimensionToPixel(widthAttribute),
      );
    }

    return _SvgDimension._(height: -1, width: -1);
  }

  final double height;
  final double width;
}

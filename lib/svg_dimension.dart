import 'package:xml/xml.dart';

class SvgDimension {
  SvgDimension._({required this.height, required this.width});
  factory SvgDimension.parse(XmlElement element) {
    final widthAttribute = element.getAttribute('width');
    final heightAttribute = element.getAttribute('height');
    final viewBoxAttribute = element.getAttribute('viewBox');

    if (viewBoxAttribute != null) {
      final viewBoxAttributeParts =
          viewBoxAttribute.split(RegExp(r'[,\s]+')).map(double.parse).toList();

      return SvgDimension._(
        width: viewBoxAttributeParts[2],
        height: viewBoxAttributeParts[3],
      );
    }

    if (widthAttribute != null && heightAttribute != null) {
      return SvgDimension._(
        height: convertDimensionToPx(heightAttribute),
        width: convertDimensionToPx(widthAttribute),
      );
    }

    return SvgDimension._(height: -1, width: -1);
  }

  final double height;
  final double width;
}

double convertDimensionToPx(String dimension) {
  final value = int.parse(dimension.replaceAll(RegExp('[^0-9.]'), ''));
  const meterToPixel = 3543.30709;
  const inchToPixel = 90.0;
  const ptToPixel = 1.25;
  const pcToPixel = 15.0;
  const ftToPixel = 1080.0;

  if (dimension.endsWith('mm')) {
    return value * (meterToPixel / 1000);
  } else if (dimension.endsWith('cm')) {
    return value * (meterToPixel / 100);
  } else if (dimension.endsWith('m')) {
    return value * meterToPixel;
  } else if (dimension.endsWith('in')) {
    return value * inchToPixel;
  } else if (dimension.endsWith('pt')) {
    return value * ptToPixel;
  } else if (dimension.endsWith('pc')) {
    return value * pcToPixel;
  } else if (dimension.endsWith('ft')) {
    return value * ftToPixel;
  } else {
    return value * 1.0;
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:xml/xml.dart';

const double _kappa = 0.5522847498307935;

/// Responsible for converting all the different svg shapes into a `path`.
class PathConverter {
  /// Converts any of svg's basic shapes into a `path` element.
  static XmlElement? fromElement(XmlElement element) {
    switch (element.name.local) {
      case ElementName.line:
        return PathConverter.fromLine(element);
      case ElementName.rect:
        return PathConverter.fromRect(element);
      case ElementName.circle:
        return PathConverter.fromCircle(element);
      case ElementName.ellipse:
        return PathConverter.fromEllipse(element);
      case ElementName.polygon:
        return PathConverter.fromPoly(element);
      case ElementName.polyline:
        return PathConverter.fromPoly(element, isPolyline: true);
    }
    return null;
  }

  /// Converts a `line` element into a `path` element.
  static XmlElement fromLine(XmlElement lineTag) {
    final filterAttributes = [
      AttributeName.x1,
      AttributeName.x2,
      AttributeName.y1,
      AttributeName.y2,
    ];
    final x1 = _getAttribute(lineTag, AttributeName.x1);
    final y1 = _getAttribute(lineTag, AttributeName.y1);
    final x2 = _getAttribute(lineTag, AttributeName.x2);
    final y2 = _getAttribute(lineTag, AttributeName.y2);
    return _buildPath(
      'M $x1 $y1 L $x2 $y2',
      lineTag,
      filterAttributes,
    );
  }

  /// Converts a `rect` element into a `path` element.
  static XmlElement fromRect(XmlElement rectTag) {
    final filterAttributes = [
      AttributeName.x,
      AttributeName.y,
      AttributeName.width,
      AttributeName.height,
      AttributeName.rx,
      AttributeName.ry,
    ];

    final x = _getAttribute(rectTag, AttributeName.x);
    final y = _getAttribute(rectTag, AttributeName.y);
    final w = _getAttribute(rectTag, AttributeName.width);
    final h = _getAttribute(rectTag, AttributeName.height);
    var rx = _getAttribute(rectTag, AttributeName.rx);
    var ry = _getAttribute(rectTag, AttributeName.ry);
    final r = _c(x + w);
    final b = _c(y + h);

    if (ry == 0) {
      ry = rx;
    } else if (rx == 0) {
      rx = ry;
    }

    return rx == 0 && ry == 0
        ? _buildPath('M $x $y H $r V $b H $x V $y Z', rectTag, filterAttributes)
        : _buildPath(
            'M ${_c(x + rx)} $y '
            'L ${_c(r - rx)} $y '
            'Q $r $y $r ${_c(y + ry)} '
            'L $r ${_c(y + h - ry)} '
            'Q $r $b ${_c(r - rx)} $b '
            'L ${_c(x + rx)} $b '
            'Q $x $b $x ${_c(b - ry)} '
            'L $x ${_c(y + ry)} '
            'Q $x $y ${_c(x + rx)} $y '
            'Z',
            rectTag,
            filterAttributes,
          );
  }

  /// Converts a `circle` element into a `path` element.
  static XmlElement fromCircle(XmlElement circleTag) {
    final filterAttributes = [
      AttributeName.cx,
      AttributeName.cy,
      AttributeName.r,
    ];

    final cx = _getAttribute(circleTag, AttributeName.cx);
    final cy = _getAttribute(circleTag, AttributeName.cy);
    final r = _getAttribute(circleTag, AttributeName.r);
    final cd = r * _kappa;

    return _buildPath(
      'M $cx ${_c(cy - r)} '
      'C ${_c(cx + cd)} ${_c(cy - r)} ${_c(cx + r)} ${_c(cy - cd)} ${_c(cx + r)} $cy '
      'C ${_c(cx + r)} ${_c(cy + cd)} ${_c(cx + cd)} ${_c(cy + r)} $cx ${_c(cy + r)} '
      'C ${_c(cx - cd)} ${_c(cy + r)} ${_c(cx - r)} ${_c(cy + cd)} ${_c(cx - r)} $cy '
      'C ${_c(cx - r)} ${_c(cy - cd)} ${_c(cx - cd)} ${_c(cy - r)} $cx ${_c(cy - r)} '
      'Z',
      circleTag,
      filterAttributes,
    );
  }

  /// Converts a `ellipse` element into a `path` element.
  static XmlElement fromEllipse(XmlElement ellipseTag) {
    final filterAttributes = [
      AttributeName.cx,
      AttributeName.cy,
      AttributeName.rx,
      AttributeName.ry,
    ];

    final cx = _getAttribute(ellipseTag, AttributeName.cx);
    final cy = _getAttribute(ellipseTag, AttributeName.cy);
    final rx = _getAttribute(ellipseTag, AttributeName.rx);
    final ry = _getAttribute(ellipseTag, AttributeName.ry);
    final cdx = rx * _kappa;
    final cdy = ry * _kappa;

    return _buildPath(
      'M $cx ${_c(cy - ry)} '
      'C ${_c(cx + cdx)} ${_c(cy - ry)} ${_c(cx + rx)} ${_c(cy - cdy)} ${_c(cx + rx)} $cy '
      'C ${_c(cx + rx)} ${_c(cy + cdy)} ${_c(cx + cdx)} ${_c(cy + ry)} $cx ${_c(cy + ry)} '
      'C ${_c(cx - cdx)} ${_c(cy + ry)} ${_c(cx - rx)} ${_c(cy + cdy)} ${_c(cx - rx)} $cy '
      'C ${_c(cx - rx)} ${_c(cy - cdy)} ${_c(cx - cdx)} ${_c(cy - ry)} $cx ${_c(cy - ry)} '
      'Z',
      ellipseTag,
      filterAttributes,
    );
  }

  /// Converts a `polygon` or `polyline` element into a `path` element. If converting a
  /// `polyline`, make sure to pass the [isPolyline] attribute as `true`.
  static XmlElement fromPoly(
    XmlElement polylineTag, {
    bool isPolyline = false,
  }) {
    final filterAttributes = [AttributeName.points];

    final points = polylineTag.getAttribute(AttributeName.points);
    final pointsArrayRaw = points != null ? points.split(',') : <String>[];
    final pointsArray = <String>[];

    for (var i = 0; i < pointsArrayRaw.length; i++) {
      final split = pointsArrayRaw[i].split(' ');
      for (var j = 0; j < split.length; j++) {
        if (split[j].isNotEmpty) {
          pointsArray.add(split[j]);
        }
      }
    }

    if (pointsArray.length.isEven) {
      final buffer = StringBuffer();
      for (var i = 0; i < pointsArray.length; i += 2) {
        buffer
          ..write(i == 0 ? 'M ' : ' L ')
          ..write('${_stod(pointsArray[i])} ${_stod(pointsArray[i + 1])}');
      }
      if (!isPolyline) {
        buffer.write(' Z');
      }
      return _buildPath(
        buffer.toString(),
        polylineTag,
        filterAttributes,
      );
    } else {
      return XmlElement(XmlName(ElementName.g));
    }
  }
}

// Clamp.
double _c(double number) => double.parse(number.toStringAsPrecision(12));

// String to double.
double _stod(String string) => _c(double.parse(string));

double _getAttribute(XmlElement element, String attribute) =>
    _stod(element.getAttribute(attribute) ?? '0');

XmlElement _buildPath(
  String path,
  XmlElement element,
  List<String> filterAttributes,
) {
  final newElement = XmlElement(
    XmlName(ElementName.path),
    [
      ...element.attributes
          .where(
            (attribute) => !filterAttributes.contains(attribute.name.local),
          )
          .map((e) => e.copy()),
      XmlAttribute(XmlName(AttributeName.d), path),
    ],
  );
  final parent = element.parent;
  if (parent != null) {
    newElement.attachParent(parent);
  }

  return newElement;
}

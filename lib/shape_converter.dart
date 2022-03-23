// ignore_for_file: lines_longer_than_80_chars

import 'package:xml/xml.dart';

class ShapeConverter {
  static const double _kappa = 0.5522847498307935;

  static double c(double number) =>
      double.parse(number.toStringAsPrecision(12));

  static double stod(String string) => c(double.parse(string));

  static XmlElement buildPath(
    String path,
    List<XmlAttribute> attributes,
    List<String> filterAttributes,
  ) =>
      XmlElement(
        XmlName('path'),
        [
          ...attributes
              .where(
                (attribute) => !filterAttributes.contains(attribute.name.local),
              )
              .map((e) => e.copy())
              .toList(),
          XmlAttribute(XmlName('d'), path),
        ],
      );

  static XmlElement lineToPath(XmlElement lineTag) {
    final filterAttributes = ['x1', 'x2', 'y1', 'y2'];
    final x1 = stod(lineTag.getAttribute('x1') ?? '0');
    final y1 = stod(lineTag.getAttribute('y1') ?? '0');
    final x2 = stod(lineTag.getAttribute('x2') ?? '0');
    final y2 = stod(lineTag.getAttribute('y2') ?? '0');
    return buildPath(
      'M $x1 $y1 L $x2 $y2',
      lineTag.attributes,
      filterAttributes,
    );
  }

  static XmlElement rectToPath(XmlElement rectTag) {
    final filterAttributes = ['x', 'y', 'width', 'height', 'rx', 'ry'];

    final x = stod(rectTag.getAttribute('x') ?? '0');
    final y = stod(rectTag.getAttribute('y') ?? '0');
    final w = stod(rectTag.getAttribute('width') ?? '0');
    final h = stod(rectTag.getAttribute('height') ?? '0');
    var rx = stod(rectTag.getAttribute('rx') ?? '0');
    var ry = stod(rectTag.getAttribute('ry') ?? '0');
    final r = c(x + w);
    final b = c(y + h);

    if (ry == 0) {
      ry = rx;
    } else if (rx == 0) {
      rx = ry;
    }

    if (rx == 0 && ry == 0) {
      return buildPath(
        'M $x $y H $r V $b H $x V $y Z',
        rectTag.attributes,
        filterAttributes,
      );
    } else {
      return buildPath(
        'M ${c(x + rx)} $y '
        'L ${c(r - rx)} $y '
        'Q $r $y $r ${c(y + ry)} '
        'L $r ${c(y + h - ry)} '
        'Q $r $b ${c(r - rx)} $b '
        'L ${c(x + rx)} $b '
        'Q $x $b $x ${c(b - ry)} '
        'L $x ${c(y + ry)} '
        'Q $x $y ${c(x + rx)} $y '
        'Z',
        rectTag.attributes,
        filterAttributes,
      );
    }
  }

  static XmlElement circleToPath(XmlElement circleTag) {
    final filterAttributes = ['cx', 'cy', 'r'];

    final cx = stod(circleTag.getAttribute('cx') ?? '0');
    final cy = stod(circleTag.getAttribute('cy') ?? '0');
    final r = stod(circleTag.getAttribute('r') ?? '0');
    final cd = r * _kappa;

    return buildPath(
      'M $cx ${c(cy - r)} '
      'C ${c(cx + cd)} ${c(cy - r)} ${c(cx + r)} ${c(cy - cd)} ${c(cx + r)} $cy '
      'C ${c(cx + r)} ${c(cy + cd)} ${c(cx + cd)} ${c(cy + r)} $cx ${c(cy + r)} '
      'C ${c(cx - cd)} ${c(cy + r)} ${c(cx - r)} ${c(cy + cd)} ${c(cx - r)} $cy '
      'C ${c(cx - r)} ${c(cy - cd)} ${c(cx - cd)} ${c(cy - r)} $cx ${c(cy - r)} '
      'Z',
      circleTag.attributes,
      filterAttributes,
    );
  }

  static XmlElement ellipseToPath(XmlElement ellipseTag) {
    final filterAttributes = ['cx', 'cy', 'rx', 'ry'];

    final cx = stod(ellipseTag.getAttribute('cx') ?? '0');
    final cy = stod(ellipseTag.getAttribute('cy') ?? '0');
    final rx = stod(ellipseTag.getAttribute('rx') ?? '0');
    final ry = stod(ellipseTag.getAttribute('ry') ?? '0');
    final cdx = rx * _kappa;
    final cdy = ry * _kappa;

    return buildPath(
      'M $cx ${c(cy - ry)} '
      'C ${c(cx + cdx)} ${c(cy - ry)} ${c(cx + rx)} ${c(cy - cdy)} ${c(cx + rx)} $cy '
      'C ${c(cx + rx)} ${c(cy + cdy)} ${c(cx + cdx)} ${c(cy + ry)} $cx ${c(cy + ry)} '
      'C ${c(cx - cdx)} ${c(cy + ry)} ${c(cx - rx)} ${c(cy + cdy)} ${c(cx - rx)} $cy '
      'C ${c(cx - rx)} ${c(cy - cdy)} ${c(cx - cdx)} ${c(cy - ry)} $cx ${c(cy - ry)} '
      'Z',
      ellipseTag.attributes,
      filterAttributes,
    );
  }

  static XmlElement polygonToPath(
    XmlElement polylineTag, {
    bool isPolyline = false,
  }) {
    final filterAttributes = ['points'];

    final points = polylineTag.getAttribute('points');
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
          ..write('${stod(pointsArray[i])} ${stod(pointsArray[i + 1])}');
      }
      if (!isPolyline) {
        buffer.write(' Z');
      }
      return buildPath(
        buffer.toString(),
        polylineTag.attributes,
        filterAttributes,
      );
    } else {
      return XmlElement(XmlName('g'));
    }
  }
}

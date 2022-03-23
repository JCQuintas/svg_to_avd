// ignore_for_file: lines_longer_than_80_chars

import 'package:xml/xml.dart';

class ShapeConverter {
  static const double _kappa = 0.5522847498307935;

  static double c(double number) {
    return double.parse(number.toStringAsPrecision(12));
  }

  static String lineToPath(XmlElement lineTag) {
    final x1 = lineTag.getAttribute('x1');
    final x2 = lineTag.getAttribute('x2');
    final y1 = lineTag.getAttribute('y1');
    final y2 = lineTag.getAttribute('y2');
    return 'M $x1 $y1 L $x2 $y2';
  }

  static String rectToPath(XmlElement rectTag) {
    final x = double.parse(rectTag.getAttribute('x') ?? '0');
    final y = double.parse(rectTag.getAttribute('y') ?? '0');
    final w = double.parse(rectTag.getAttribute('width') ?? '0');
    final h = double.parse(rectTag.getAttribute('height') ?? '0');
    var rx = double.parse(rectTag.getAttribute('rx') ?? '0');
    var ry = double.parse(rectTag.getAttribute('ry') ?? '0');
    final r = c(x + w);
    final b = c(y + h);

    if (ry == 0) {
      ry = rx;
    } else if (rx == 0) {
      rx = ry;
    }

    if (rx == 0 && ry == 0) {
      return 'M $x $y H $r V $b H $x V $y Z';
    } else {
      return 'M ${c(x + rx)} $y '
          'L ${c(r - rx)} $y '
          'Q $r $y $r ${c(y + ry)} '
          'L $r ${c(y + h - ry)} '
          'Q $r $b ${c(r - rx)} $b '
          'L ${c(x + rx)} $b '
          'Q $x $b $x ${c(b - ry)} '
          'L $x ${c(y + ry)} '
          'Q $x $y ${c(x + rx)} $y '
          'Z';
    }
  }

  static String circleToPath(XmlElement circleTag) {
    final cx = double.parse(circleTag.getAttribute('cx') ?? '0');
    final cy = double.parse(circleTag.getAttribute('cy') ?? '0');
    final r = double.parse(circleTag.getAttribute('r') ?? '0');
    final cd = r * _kappa;

    return 'M $cx ${c(cy - r)} '
        'C ${c(cx + cd)} ${c(cy - r)} ${c(cx + r)} ${c(cy - cd)} ${c(cx + r)} $cy '
        'C ${c(cx + r)} ${c(cy + cd)} ${c(cx + cd)} ${c(cy + r)} $cx ${c(cy + r)} '
        'C ${c(cx - cd)} ${c(cy + r)} ${c(cx - r)} ${c(cy + cd)} ${c(cx - r)} $cy '
        'C ${c(cx - r)} ${c(cy - cd)} ${c(cx - cd)} ${c(cy - r)} $cx ${c(cy - r)} '
        'Z';
  }

  static String ellipseToPath(XmlElement ellipseTag) {
    final cx = double.parse(ellipseTag.getAttribute('cx') ?? '0');
    final cy = double.parse(ellipseTag.getAttribute('cy') ?? '0');
    final rx = double.parse(ellipseTag.getAttribute('rx') ?? '0');
    final ry = double.parse(ellipseTag.getAttribute('ry') ?? '0');
    final cdx = rx * _kappa;
    final cdy = ry * _kappa;

    return 'M $cx ${c(cy - ry)} '
        'C ${c(cx + cdx)} ${c(cy - ry)} ${c(cx + rx)} ${c(cy - cdy)} ${c(cx + rx)} $cy '
        'C ${c(cx + rx)} ${c(cy + cdy)} ${c(cx + cdx)} ${c(cy + ry)} $cx ${c(cy + ry)} '
        'C ${c(cx - cdx)} ${c(cy + ry)} ${c(cx - rx)} ${c(cy + cdy)} ${c(cx - rx)} $cy '
        'C ${c(cx - rx)} ${c(cy - cdy)} ${c(cx - cdx)} ${c(cy - ry)} $cx ${c(cy - ry)} '
        'Z';
  }

  static String? polygonToPath(
    XmlElement polylineTag, {
    bool isPolyline = false,
  }) {
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
          ..write(i == 0 ? 'M ' : 'L ')
          ..write('${pointsArray[i]} ${pointsArray[i + 1]}');
      }
      if (!isPolyline) {
        buffer.write('Z');
      }
      return buffer.toString();
    } else {
      return null;
    }
  }
}

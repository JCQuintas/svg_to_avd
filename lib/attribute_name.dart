// ignore_for_file: public_member_api_docs, self explanatory.

import 'package:svg_to_avd/errors/invalid_attribute_name_exception.dart';

String _android(String key) => 'android:$key';

/// Class to hold all used attribute names statically.
class AttributeName {
  static const String opacity = 'opacity';
  static const String fillOpacity = 'fill-opacity';
  static const String strokeOpacity = 'stroke-opacity';
  static const String fill = 'fill';
  static const String fillRule = 'fill-rule';
  static const String stroke = 'stroke';
  static const String strokeWidth = 'stroke-width';
  static const String strokeLineJoin = 'stroke-linejoin';
  static const String strokeMiterLimit = 'stroke-miterlimit';
  static const String strokeLineCap = 'stroke-linecap';
  static const String d = 'd';
  static const String width = 'width';
  static const String height = 'height';

  static const String x = 'x';
  static const String x1 = 'x1';
  static const String x2 = 'x2';
  static const String y = 'y';
  static const String y1 = 'y1';
  static const String y2 = 'y2';
  static const String r = 'r';
  static const String rx = 'rx';
  static const String ry = 'ry';
  static const String cx = 'cx';
  static const String cy = 'cy';
  static const String points = 'points';

  static const String transform = 'transform';

  // General.
  static final String androidFillColor = _android('fillColor');
  static final String androidFillAlpha = _android('fillAlpha');
  static final String androidFillType = _android('fillType');
  static final String androidStrokeColor = _android('strokeColor');
  static final String androidStrokeAlpha = _android('strokeAlpha');
  static final String androidStrokeWidth = _android('strokeWidth');
  static final String androidStrokeLineJoin = _android('strokeLineJoin');
  static final String androidStrokeMiterLimit = _android('strokeMiterLimit');
  static final String androidStrokeLineCap = _android('strokeLineCap');
  static final String androidPathData = _android('pathData');
  static final String androidWidth = _android('width');
  static final String androidHeight = _android('height');
  static final String androidViewportWidth = _android('viewportWidth');
  static final String androidViewportHeight = _android('viewportHeight');

  // Transforms.
  static final String androidTranslateX = _android('translateX');
  static final String androidTranslateY = _android('translateY');
  static final String androidScaleX = _android('scaleX');
  static final String androidScaleY = _android('scaleY');
  static final String androidRotation = _android('rotation');
  static final String androidPivotX = _android('pivotX');
  static final String androidPivotY = _android('pivotY');

  static final _convertMap = {
    fill: androidFillColor,
    fillOpacity: androidFillAlpha,
    fillRule: androidFillType,
    stroke: androidStrokeColor,
    strokeOpacity: androidStrokeAlpha,
    strokeWidth: androidStrokeWidth,
    strokeLineJoin: androidStrokeLineJoin,
    strokeMiterLimit: androidStrokeMiterLimit,
    strokeLineCap: androidStrokeLineCap,
    d: androidPathData,
    width: androidWidth,
    height: androidHeight,
  };

  /// Converts a given svg attribute name into its android counterpart.
  /// Throws if there is no counterpart.
  static String toAndroid(String attributeName) {
    final value = _convertMap[attributeName];
    if (value == null) {
      throw InvalidAttributeNameException(attributeName);
    }
    return value;
  }
}

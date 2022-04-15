import 'package:svg_to_avd/errors/invalid_attribute_name_exception.dart';

String android(String key) => 'android:$key';

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
  static final String androidFillColor = android('fillColor');
  static final String androidFillAlpha = android('fillAlpha');
  static final String androidFillType = android('fillType');
  static final String androidStrokeColor = android('strokeColor');
  static final String androidStrokeAlpha = android('strokeAlpha');
  static final String androidStrokeWidth = android('strokeWidth');
  static final String androidStrokeLineJoin = android('strokeLineJoin');
  static final String androidStrokeMiterLimit = android('strokeMiterLimit');
  static final String androidStrokeLineCap = android('strokeLineCap');
  static final String androidPathData = android('pathData');
  static final String androidWidth = android('width');
  static final String androidHeight = android('height');
  static final String androidViewportWidth = android('viewportWidth');
  static final String androidViewportHeight = android('viewportHeight');

  // Transforms.
  static final String androidTranslateX = android('translateX');
  static final String androidTranslateY = android('translateY');
  static final String androidScaleX = android('scaleX');
  static final String androidScaleY = android('scaleY');
  static final String androidRotation = android('rotation');
  static final String androidPivotX = android('pivotX');
  static final String androidPivotY = android('pivotY');

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

  static String toAndroid(String attributeName) {
    final value = _convertMap[attributeName];
    if (value == null) {
      throw InvalidAttributeNameException(attributeName);
    }
    return value;
  }
}

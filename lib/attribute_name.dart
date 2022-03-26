import 'package:svg_to_avd/errors/invalid_attribute_name_exception.dart';

String android(String key) => 'android:$key';

class AttributeName {
  static String opacity = 'opacity';
  static String fillOpacity = 'fill-opacity';
  static String strokeOpacity = 'stroke-opacity';
  static String fill = 'fill';
  static String fillRule = 'fill-rule';
  static String stroke = 'stroke';
  static String strokeWidth = 'stroke-width';
  static String strokeLineJoin = 'stroke-linejoin';
  static String strokeMiterLimit = 'stroke-miterlimit';
  static String strokeLineCap = 'stroke-linecap';
  static String d = 'd';
  static String transform = 'transform';

  // general
  static String androidFillColor = android('fillColor');
  static String androidFillAlpha = android('fillAlpha');
  static String androidFillType = android('fillType');
  static String androidStrokeColor = android('strokeColor');
  static String androidStrokeAlpha = android('strokeAlpha');
  static String androidStrokeWidth = android('strokeWidth');
  static String androidStrokeLineJoin = android('strokeLineJoin');
  static String androidStrokeMiterLimit = android('strokeMiterLimit');
  static String androidStrokeLineCap = android('strokeLineCap');
  static String androidPathData = android('pathData');

  // transforms
  static String androidTranslateX = android('translateX');
  static String androidTranslateY = android('translateY');
  static String androidScaleX = android('scaleX');
  static String androidScaleY = android('scaleY');
  static String androidRotate = android('rotate');
  static String androidRotatePivotX = android('rotatePivotX');
  static String androidRotatePivotY = android('rotatePivotY');

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
  };

  static String toAndroid(String attributeName) {
    final value = _convertMap[attributeName];
    if (value == null) {
      throw InvalidAttributeNameException(attributeName);
    }
    return value;
  }
}

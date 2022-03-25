import 'package:svg_to_vector_drawable/errors/invalid_attribute_name_exception.dart';

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

  static final _convertMap = {
    fill: android('fillColor'),
    fillOpacity: android('fillAlpha'),
    fillRule: android('fillType'),
    stroke: android('strokeColor'),
    strokeOpacity: android('strokeAlpha'),
    strokeWidth: android('strokeWidth'),
    strokeLineJoin: android('strokeLineJoin'),
    strokeMiterLimit: android('strokeMiterLimit'),
    strokeLineCap: android('strokeLineCap'),
    d: android('pathData'),
  };

  static String toAndroid(String attributeName) {
    final value = _convertMap[attributeName];
    if (value == null) {
      throw InvalidAttributeNameException(attributeName);
    }
    return value;
  }
}

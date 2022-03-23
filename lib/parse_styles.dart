import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:xml/xml.dart';

Map<String, String> parseStyles(XmlElement element, CssMap cssMap) {
  final attributes = element.attributes;
  final stylesArray = <String, String>{};
  for (var n = 0; n < attributes.length; n++) {
    final name = attributes[n].name.local;
    var value = attributes[n].value;
    if (name == 'style') {
      if (!value.endsWith(';')) value += ';';

      parseCss(value).attributes.forEach((key, value) {
        stylesArray[key] = value;
      });
    } else if (name == 'class') {
      final val = '.${value.trim()}';
      if (cssMap.children.isNotEmpty && cssMap.children[val] != null) {
        cssMap.children[val]?.attributes.forEach((key, value) {
          stylesArray[key] = value;
        });
      }
    } else {
      stylesArray[name] = value;
    }
  }

  return stylesArray;
}

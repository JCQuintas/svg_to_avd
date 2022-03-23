import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:svg_to_vector_drawable/parse_styles.dart';
import 'package:xml/xml.dart';

List<Map<String, String>> getStyles(XmlElement element, CssMap cssMap) {
  final styles = parseStyles(element, cssMap);

  final parentStyles = <String, String>{};

  for (final current in element.ancestorElements.toList().reversed) {
    for (final entry in parseStyles(current, cssMap).entries) {
      if (entry.key != 'id') {
        parentStyles[entry.key] = entry.value;
      }
    }
  }

  return [styles, parentStyles];
}

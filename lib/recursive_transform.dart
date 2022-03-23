import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:svg_to_vector_drawable/parse_group.dart';
import 'package:xml/xml.dart';

class Tags {
  static String anchor = 'a';
  static String group = 'g';
  static String path = 'path';
  static String line = 'line';
  static String rect = 'rect';
  static String circle = 'circle';
  static String ellipse = 'ellipse';
  static String polyline = 'polyline';
  static String polygon = 'polygon';
  static String text = 'text';
  static String image = 'image';
}

List<String> recursiveTransform(
  XmlElement parent,
  CssMap cssMap, {
  int groupLevel = 0,
  bool clipPath = false,
  List<String>? nodeList,
}) {
  final _nodeList = nodeList ?? [];

  for (final element in parent.childElements) {
    if (element.name.local == Tags.anchor && element.children.isNotEmpty) {
      recursiveTransform(
        element,
        cssMap,
        groupLevel: groupLevel,
        clipPath: clipPath,
        nodeList: _nodeList,
      );
    } else if (element.name.local == Tags.group &&
        element.children.isNotEmpty) {
      final groupTransform = parseGroup(element, cssMap);

      recursiveTransform(
        element,
        cssMap,
        groupLevel: groupLevel,
        clipPath: clipPath,
        nodeList: _nodeList,
      );

      // if (ignoreGroup) printGroupStart(group, groupLevel);

      // if (ignoreGroup) groupLevel++;
      // recursiveTreeWalk(current, groupLevel, clipPath);
      // if (ignoreGroup) groupLevel--;

      // if (ignoreGroup) printGroupEnd(groupLevel);

    }
  }

  return _nodeList;
}

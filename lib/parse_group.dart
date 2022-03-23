import 'package:svg_to_vector_drawable/get_styles.dart';
import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:xml/xml.dart';

class GroupTransform {
  int transformX = 0;
  int transformY = 0;
  int scaleX = 1;
  int scaleY = 1;
  int rotate = 0;
  int rotatePivotX = -1;
  int rotatePivotY = -1;
  String id = '';
  bool isSet = false;
  String? clipPathId;
}

GroupTransform parseGroup(XmlElement groupTag, CssMap cssMap) {
  final transform = groupTag.getAttribute('transform');
  final id = groupTag.getAttribute('id');
  final groupTransform = GroupTransform();

  if (transform != null) {
    final regex = RegExp(r'((\w|\s)+)\(([^)]+)', multiLine: true);
    var startIndex = 0;
    var match = regex.allMatches(transform, startIndex);

    while (match.isNotEmpty) {
      startIndex = match.first.end;
      final split = match.first.group(3)?.split(RegExp(r'[,\s]+'));
      final transformName = match.first.group(3)?.trim();

      if (transformName == 'translate') {
        groupTransform
          ..transformX = int.parse(split?.elementAt(0) ?? '0')
          ..transformY = int.parse(split?.elementAt(1) ?? '0')
          ..isSet = true;
      } else if (transformName == 'scale') {
        groupTransform
          ..scaleX = int.parse(split?.elementAt(0) ?? '0')
          ..scaleY = int.parse(split?.elementAt(1) ?? '0')
          ..isSet = true;
      } else if (transformName == 'rotate') {
        groupTransform
          ..rotate = int.parse(split?.elementAt(0) ?? '0')
          ..rotatePivotX = int.parse(split?.elementAt(1) ?? '-1')
          ..rotatePivotY = int.parse(split?.elementAt(2) ?? '-1')
          ..isSet = true;
      }

      match = regex.allMatches(transform, startIndex);
    }
  }

  if (id != null) {
    groupTransform.id = id;
  }

  final styles = getStyles(groupTag, cssMap)[0];
  if (styles['clip-path'] != null) {
    groupTransform
      ..isSet = true
      ..clipPathId = styles['clip-path'];
  }

  return groupTransform;
}

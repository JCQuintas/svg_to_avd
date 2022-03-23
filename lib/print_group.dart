import 'package:svg_to_vector_drawable/constants.dart';
import 'package:svg_to_vector_drawable/generate_attribute.dart';
import 'package:svg_to_vector_drawable/parse_group.dart';

String getGroupStart(GroupTransform transform, int groupLevel) {
  final buffer = StringBuffer()
    ..write(indent * (groupLevel + 1))
    ..writeln('<group')
    ..writeln(
      generateAttr(
        'translateX',
        transform.transformX.toString(),
        groupLevel: groupLevel + 1,
        defaultValue: 0,
      ),
    )
    ..writeln(
      generateAttr(
        'translateY',
        transform.transformY.toString(),
        groupLevel: groupLevel + 1,
        defaultValue: 0,
      ),
    )
    ..writeln(
      generateAttr(
        'scaleX',
        transform.scaleX.toString(),
        groupLevel: groupLevel + 1,
        defaultValue: 1,
      ),
    )
    ..writeln(
      generateAttr(
        'scaleY',
        transform.scaleY.toString(),
        groupLevel: groupLevel + 1,
        defaultValue: 1,
      ),
    )
    ..writeln('>');

//   checkForClipPath(groupTransform.clipPathId, groupLevel + 1);

  return buffer.toString();
}

String getGroupEnd(int groupLevel) {
  return '${indent * (groupLevel + 1)}</group>';
}

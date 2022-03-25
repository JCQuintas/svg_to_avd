import 'package:svg_to_vector_drawable/attribute_name.dart';
import 'package:xml/xml.dart';

const String defaultTranslate = '0';
const String defaultScale = '1';
const String defaultRotate = '0';
const String defaultRotatePivot = '-1';

void addIfValid(
  List<XmlAttribute> list,
  String? value,
  String defaultValue,
  String attributeName,
) {
  if (value != null && value != defaultValue) {
    list.add(
      XmlAttribute(XmlName(attributeName), value),
    );
  }
}

List<XmlAttribute> transformConverter(String? transform) {
  if (transform == null) return [];

  final transformAttributes = <XmlAttribute>[];

  final regex = RegExp(r'((\w|\s)+)\(([^)]+)', multiLine: true);
  var startIndex = 0;
  var match = regex.allMatches(transform, startIndex);

  while (match.isNotEmpty) {
    startIndex = match.first.end;
    final split = match.first.group(3)?.split(RegExp(r'[,\s]+'));
    final transformName = match.first.group(1)?.trim();

    if (transformName == 'translate') {
      final x = split?.elementAt(0);
      final y = split?.elementAt(1);

      addIfValid(
        transformAttributes,
        x,
        defaultTranslate,
        AttributeName.androidTranslateX,
      );
      addIfValid(
        transformAttributes,
        y,
        defaultTranslate,
        AttributeName.androidTranslateY,
      );
    } else if (transformName == 'scale') {
      final x = split?.elementAt(0);
      final y = split?.elementAt(1);

      addIfValid(
        transformAttributes,
        x,
        defaultScale,
        AttributeName.androidScaleX,
      );
      addIfValid(
        transformAttributes,
        y,
        defaultScale,
        AttributeName.androidScaleY,
      );
    } else if (transformName == 'rotate') {
      final r = split?.elementAt(0);
      final x = split?.elementAt(1);
      final y = split?.elementAt(2);

      addIfValid(
        transformAttributes,
        r,
        defaultRotate,
        AttributeName.androidRotate,
      );
      addIfValid(
        transformAttributes,
        x,
        defaultRotatePivot,
        AttributeName.androidRotatePivotX,
      );
      addIfValid(
        transformAttributes,
        y,
        defaultRotatePivot,
        AttributeName.androidRotatePivotY,
      );
    }

    match = regex.allMatches(transform, startIndex);
  }

  return transformAttributes;
}

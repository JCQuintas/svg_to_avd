import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:xml/xml.dart';

const String _translate = '0';
const String _scale = '1';
const String _rotate = '0';
const String _pivot = '-1';

typedef AN = AttributeName;

class TransformConverter {
  static List<XmlAttribute> fromString(String? transform) {
    if (transform == null) return [];

    final transformAttributes = <XmlAttribute>[];

    final transformRegExp = RegExp(r'((\w|\s)+)\(([^)]+)', multiLine: true);
    var startIndex = 0;
    var match = transformRegExp.allMatches(transform, startIndex);

    while (match.isNotEmpty) {
      startIndex = match.first.end;
      final entriesRegExp = RegExp(r'[,\s]+');
      final split = match.first.group(3)?.split(entriesRegExp);
      final transformName = match.first.group(1)?.trim();

      if (transformName == 'translate') {
        final x = _getElementAt(split, 0);
        final y = _getElementAt(split, 1);

        _addIfValid(transformAttributes, x, _translate, AN.androidTranslateX);
        _addIfValid(transformAttributes, y, _translate, AN.androidTranslateY);
      } else if (transformName == 'scale') {
        final x = _getElementAt(split, 0);
        final y = _getElementAt(split, 1);

        _addIfValid(transformAttributes, x, _scale, AN.androidScaleX);
        _addIfValid(transformAttributes, y, _scale, AN.androidScaleY);
      } else if (transformName == 'rotate') {
        final r = _getElementAt(split, 0);
        final x = _getElementAt(split, 1);
        final y = _getElementAt(split, 2);

        _addIfValid(transformAttributes, r, _rotate, AN.androidRotation);
        _addIfValid(transformAttributes, x, _pivot, AN.androidPivotX);
        _addIfValid(transformAttributes, y, _pivot, AN.androidPivotY);
      }

      match = transformRegExp.allMatches(transform, startIndex);
    }

    return transformAttributes;
  }

  static XmlElement? fromElement(XmlElement element) {
    if (element.name.local != ElementName.g) return null;

    return XmlElement(
      XmlName(ElementName.group),
      fromString(element.getAttribute(AttributeName.transform)),
      element.children.map((child) => child.copy()),
      element.isSelfClosing,
    );
  }
}

void _addIfValid(
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

String? _getElementAt(List<String>? list, int index) {
  if (list != null && list.length >= index + 1) {
    return list.elementAt(index);
  }

  return null;
}

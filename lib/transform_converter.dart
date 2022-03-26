import 'package:svg_to_vector_drawable/attribute_name.dart';
import 'package:xml/xml.dart';

const String _defaultTranslate = '0';
const String _defaultScale = '1';
const String _defaultRotate = '0';
const String _defaultRotatePivot = '-1';

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

        _addIfValid(
          transformAttributes,
          x,
          _defaultTranslate,
          AttributeName.androidTranslateX,
        );
        _addIfValid(
          transformAttributes,
          y,
          _defaultTranslate,
          AttributeName.androidTranslateY,
        );
      } else if (transformName == 'scale') {
        final x = _getElementAt(split, 0);
        final y = _getElementAt(split, 1);

        _addIfValid(
          transformAttributes,
          x,
          _defaultScale,
          AttributeName.androidScaleX,
        );
        _addIfValid(
          transformAttributes,
          y,
          _defaultScale,
          AttributeName.androidScaleY,
        );
      } else if (transformName == 'rotate') {
        final r = _getElementAt(split, 0);
        final x = _getElementAt(split, 1);
        final y = _getElementAt(split, 2);

        _addIfValid(
          transformAttributes,
          r,
          _defaultRotate,
          AttributeName.androidRotate,
        );
        _addIfValid(
          transformAttributes,
          x,
          _defaultRotatePivot,
          AttributeName.androidRotatePivotX,
        );
        _addIfValid(
          transformAttributes,
          y,
          _defaultRotatePivot,
          AttributeName.androidRotatePivotY,
        );
      }

      match = transformRegExp.allMatches(transform, startIndex);
    }

    return transformAttributes;
  }

  static XmlElement fromElement(XmlElement element) {
    return XmlElement(
      element.name.copy(),
      [
        ...fromString(element.getAttribute(AttributeName.transform)),
        ...element.attributes
            .where(
              (attribute) => attribute.name.local != AttributeName.transform,
            )
            .map((attribute) => attribute.copy())
      ],
      element.children.map((child) => child.copy()),
      element.isSelfClosing,
    );
  }
}

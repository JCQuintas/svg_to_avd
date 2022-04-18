import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/element_name.dart';
import 'package:xml/xml.dart';

const String _translate = '0';
const String _scale = '1';
const String _rotate = '0';
const String _pivot = '-1';

/// Responsible for converting the `transform` attributes or `g` elements.
class TransformConverter {
  /// Converts a `transform` value into a list of attributes that can be added
  /// to a `group` element.
  ///
  /// eg:
  /// ```dart
  /// TransformConverter.fromString('rotate(-10) translate(10 10)');
  /// ```
  static List<XmlAttribute> fromString(String? transform) {
    if (transform == null) return [];

    final attributes = <XmlAttribute>[];

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

        _addIfValid(attributes, x, _translate, AttributeName.androidTranslateX);
        _addIfValid(attributes, y, _translate, AttributeName.androidTranslateY);
      } else if (transformName == 'scale') {
        final x = _getElementAt(split, 0);
        final y = _getElementAt(split, 1);

        _addIfValid(attributes, x, _scale, AttributeName.androidScaleX);
        _addIfValid(attributes, y, _scale, AttributeName.androidScaleY);
      } else if (transformName == 'rotate') {
        final r = _getElementAt(split, 0);
        final x = _getElementAt(split, 1);
        final y = _getElementAt(split, 2);

        _addIfValid(attributes, r, _rotate, AttributeName.androidRotation);
        _addIfValid(attributes, x, _pivot, AttributeName.androidPivotX);
        _addIfValid(attributes, y, _pivot, AttributeName.androidPivotY);
      }

      match = transformRegExp.allMatches(transform, startIndex);
    }

    return attributes;
  }

  /// Converts a `g` element into a `group` element. It returns null if the
  /// input is not a `g` element.
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

import 'package:svg_to_vector_drawable/transform_converter.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('TransformConverter.fromElement', () {
    test('parses transform properties and keep unchanged props in place', () {
      final element = XmlDocument.parse(
        '<svg '
        'transform=" '
        'rotate(-10 50 100) '
        'translate(-36 45.5) '
        'skewX(40) '
        'scale(1 0.5) '
        '" '
        'stroke="#ffffff" '
        '/>',
      ).getElement('svg')!;

      final result = TransformConverter.fromElement(element);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<svg '
          'android:rotate="-10" '
          'android:rotatePivotX="50" '
          'android:rotatePivotY="100" '
          'android:translateX="-36" '
          'android:translateY="45.5" '
          'android:scaleY="0.5" '
          'stroke="#ffffff" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });
  });
  group('TransformConverter.fromString', () {
    test(
        'parses the transform properties to their correct android counterparts',
        () {
      final transform = XmlDocument.parse(
        '<svg '
        'transform=" '
        'rotate(-10 50 100) '
        'translate(-36 45.5) '
        'skewX(40) '
        'scale(1 0.5) '
        '"/>',
      ).getElement('svg')!.getAttribute('transform');

      final result = TransformConverter.fromString(transform);

      expect(result.isNotEmpty, true);
      expect(
        XmlElement(XmlName('svg'), result).toXmlString(pretty: true),
        XmlDocument.parse(
          '<svg '
          'android:rotate="-10" '
          'android:rotatePivotX="50" '
          'android:rotatePivotY="100" '
          'android:translateX="-36" '
          'android:translateY="45.5" '
          'android:scaleY="0.5" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });

    test('returns an empty array when transform is null', () {
      final result = TransformConverter.fromString(null);

      expect(result.isEmpty, true);
    });

    test('returns an empty array when transform is invalid string', () {
      final result = TransformConverter.fromString('null');

      expect(result.isEmpty, true);
    });
  });
}

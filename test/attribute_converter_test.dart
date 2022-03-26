import 'package:svg_to_avd/attribute_converter.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

class TestCase {
  TestCase({
    required this.title,
    required this.input,
    required this.output,
    this.isElementTestOnly = false,
  });

  final String title;
  final String input;
  final String output;
  final bool isElementTestOnly;
}

final List<TestCase> testCases = [
  TestCase(
    title: 'converts opacity in a given element to stroke and fill alpha',
    input: '<svg opacity="0.5" />',
    output: '<svg '
        'android:fillAlpha="0.5" '
        'android:strokeAlpha="0.5" '
        'android:fillColor="#000000" '
        'android:strokeWidth="1" '
        '/>',
  ),
  TestCase(
    title:
        'converts existing stroke or fill opacity by multiplying it by opacity',
    input: '<svg opacity="0.5" fill-opacity="0.5" stroke-opacity="0.2"/>',
    output: '<svg '
        'android:fillAlpha="0.25" '
        'android:strokeAlpha="0.1" '
        'android:fillColor="#000000" '
        'android:strokeWidth="1"'
        '/>',
  ),
  TestCase(
    title: 'keeps existing fill value if present',
    input: '<svg fill="#ffffff"/>',
    output: '<svg android:fillColor="#ffffff"/>',
  ),
  TestCase(
    title: 'keeps fill-rule when it is evenOdd',
    input: '<svg fill-rule="evenOdd"/>',
    output: '<svg android:fillColor="#000000" android:fillType="evenOdd"/>',
  ),
  TestCase(
    title: 'keeps fill-rule when it is nonZero',
    input: '<svg fill-rule="nonZero"/>',
    output: '<svg android:fillColor="#000000" android:fillType="nonZero"/>',
  ),
  TestCase(
    title: 'keeps stroke-width when it exists',
    input: '<svg stroke-width="2"/>',
    output: '<svg android:fillColor="#000000" android:strokeWidth="2"/>',
  ),
  TestCase(
    title: 'convert names of all other attributes',
    input: '<svg '
        'stroke="#ffffff" '
        'stroke-linejoin="miter" '
        'stroke-linecap="round" '
        'stroke-miterlimit="1" '
        'd="M1,1 h4 M1,3 h4 M1,5 h4" '
        '/>',
    output: '<svg '
        'android:fillColor="#000000" '
        'android:strokeWidth="1" '
        'android:strokeColor="#ffffff" '
        'android:strokeLineJoin="miter" '
        'android:strokeMiterLimit="1" '
        'android:strokeLineCap="round" '
        'android:pathData="M1,1 h4 M1,3 h4 M1,5 h4" '
        '/>',
  ),
  TestCase(
    title: 'wraps element in a group when it contains transforms',
    input: '<svg transform="translate(25)"/>',
    output:
        '<group android:translateX="25"><svg android:fillColor="#000000" /></group>',
    isElementTestOnly: true,
  ),
];

void main() {
  group('AttributeConverter.fromElement', () {
    for (final testCase in testCases) {
      test(testCase.title, () {
        final baseElement =
            XmlDocument.parse(testCase.input).getElement('svg')!;

        final result = AttributeConverter.fromElement(baseElement);

        expect(
          result.toXmlString(pretty: true),
          XmlDocument.parse(testCase.output).toXmlString(pretty: true),
        );
      });
    }

    test('inherits styles from parent "g" element', () {
      final baseElement = XmlDocument.parse(
        '<g stroke-width="5" fill="#777777"> '
        '<g fill-rule="evenOdd"> '
        '<svg fill="#ffffff"/> '
        '</g>'
        '</g>',
      ).getElement('g')?.getElement('g')?.getElement('svg');

      final result = AttributeConverter.fromElement(baseElement!);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<svg '
          'android:fillColor="#ffffff" '
          'android:fillType="evenOdd" '
          'android:strokeWidth="5" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });
  });

  group('AttributeConverter.fromAttributes', () {
    for (final testCase in testCases.where((v) => !v.isElementTestOnly)) {
      test(testCase.title, () {
        final baseElement =
            XmlDocument.parse(testCase.input).getElement('svg')!;

        final result = AttributeConverter.fromAttributes(
          baseElement.attributes,
        );

        expect(
          XmlElement(XmlName('svg'), result).toXmlString(pretty: true),
          XmlDocument.parse(testCase.output).toXmlString(pretty: true),
        );
      });
    }
  });
}

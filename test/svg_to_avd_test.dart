import 'package:svg_to_avd/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_avd/svg_to_avd.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import 'helpers/helpers.dart';

void main() {
  group('svgToAvd', () {
    test('parses the use attribute', () {
      final result = svgToAvd(fixture('use.svg'));

      expect(result, fixture('use_result.svg'));
    });

    test('throws a XmlParserException when input is not valid svg or xml', () {
      void shouldThrow() => svgToAvd('svg error');

      expect(shouldThrow, throwsA(isA<XmlParserException>()));
    });

    test('throws an InvalidSvgStringException error when input is not a svg',
        () {
      void shouldThrow() => svgToAvd('<nice></nice>');

      expect(shouldThrow, throwsA(isA<InvalidSvgStringException>()));
    });
  });
}
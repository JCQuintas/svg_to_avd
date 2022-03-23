import 'package:svg_to_vector_drawable/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_vector_drawable/svg_to_vector_drawable.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import 'helpers/helpers.dart';

void main() {
  group('svgToVectorDrawable', () {
    test('parses the use attribute', () {
      final result = svgToVectorDrawable(fixture('use.svg'));

      expect(result, fixture('use_result.svg'));
    });

    test('throws a XmlParserException when input is not valid svg or xml', () {
      void shouldThrow() => svgToVectorDrawable('svg error');

      expect(shouldThrow, throwsA(isA<XmlParserException>()));
    });

    test('throws an InvalidSvgStringException error when input is not a svg',
        () {
      void shouldThrow() => svgToVectorDrawable('<nice></nice>');

      expect(shouldThrow, throwsA(isA<InvalidSvgStringException>()));
    });
  });
}

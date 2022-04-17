import 'dart:io';

import 'package:svg_to_avd/svg_to_avd.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

final inputSvgFile = File('./test/fixture/svg_file.svg');
final resultXmlFile = File('./test/fixture/svg_file_result.xml');

void main() {
  group('SvgToAvd.fromString', () {
    test(
      'parses the svg into a avd string',
      () {
        final input = inputSvgFile.readAsStringSync();

        final result = SvgToAvd.fromString(input);

        expect(
          result.toPrettyXmlString(),
          XmlDocument.parse(resultXmlFile.readAsStringSync())
              .toXmlString(pretty: true),
        );
      },
    );

    test('throws a XmlParserException when input is not valid svg or xml', () {
      void shouldThrow() => SvgToAvd.fromString('svg error');

      expect(shouldThrow, throwsA(isA<InvalidSvgStringException>()));
    });

    test(
      'throws an InvalidSvgStringException error when input is not a svg',
      () {
        void shouldThrow() => SvgToAvd.fromString('<nice></nice>');

        expect(shouldThrow, throwsA(isA<InvalidSvgStringException>()));
      },
    );
  });
}

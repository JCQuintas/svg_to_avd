import 'package:svg_to_vector_drawable/replace_use_tags.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import 'helpers/helpers.dart';

void main() {
  group('svgToVectorDrawable', () {
    test('parses the use attribute', () {
      final baseElement =
          XmlDocument.parse(fixture('use.svg')).getElement('svg')!;

      replaceUseTags(baseElement);

      expect(baseElement.toXmlString(pretty: true), fixture('use_result.svg'));
    });
  });
}

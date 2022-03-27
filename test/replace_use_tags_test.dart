import 'package:svg_to_avd/replace_use_tags.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('replaceUseTags', () {
    test('parses the use attribute', () {
      final baseElement = XmlDocument.parse(
        '''
          <svg viewBox="0 0 30 10" xmlns="http://www.w3.org/2000/svg">
            <circle id="myCircle" cx="5" cy="5" r="4" stroke="blue"/>
            <use href="#myCircle" x="10" fill="blue"/>
            <use xlink:href="#myCircle" x="20" fill="white" stroke="red"/>
          </svg>
        ''',
      ).getElement('svg')!;

      replaceUseTags(baseElement);

      expect(
        baseElement.toXmlString(pretty: true),
        XmlDocument.parse(
          '''
            <svg viewBox="0 0 30 10" xmlns="http://www.w3.org/2000/svg">
              <circle id="myCircle" cx="5" cy="5" r="4" stroke="blue"/>
              <circle cx="5" cy="5" r="4" stroke="blue" x="10" fill="blue"/>
              <circle cx="5" cy="5" r="4" stroke="red" x="20" fill="white"/>
            </svg>
          ''',
        ).toXmlString(pretty: true),
      );
    });

    test('parses nested use attributes', () {
      final baseElement = XmlDocument.parse(
        '''
          <svg viewBox="0 0 30 10" xmlns="http://www.w3.org/2000/svg">
            <circle id="myCircle" cx="5" cy="5" r="4" stroke="blue"/>
            <g>
              <use href="#myCircle" x="10" fill="blue"/>
            </g>
            <use xlink:href="#myCircle" x="20" fill="white" stroke="red"/>
          </svg>
        ''',
      ).getElement('svg')!;

      replaceUseTags(baseElement);

      expect(
        baseElement.toXmlString(pretty: true),
        XmlDocument.parse(
          '''
            <svg viewBox="0 0 30 10" xmlns="http://www.w3.org/2000/svg">
              <circle id="myCircle" cx="5" cy="5" r="4" stroke="blue"/>
              <g>
                <circle cx="5" cy="5" r="4" stroke="blue" x="10" fill="blue"/>
              </g>
              <circle cx="5" cy="5" r="4" stroke="red" x="20" fill="white"/>
            </svg>
          ''',
        ).toXmlString(pretty: true),
      );
    });
  });
}

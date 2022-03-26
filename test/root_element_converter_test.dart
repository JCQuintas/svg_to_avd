import 'package:svg_to_avd/root_element_converter.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('RootElementConverter.fromElement', () {
    test('parses the viewBox attribute', () {
      final baseElement = XmlDocument.parse(
        '<svg '
        'width="26" '
        'height="24" '
        'viewBox="0 0 26 24" '
        'fill="none" '
        'xmlns="http://www.w3.org/2000/svg" '
        '/>',
      ).getElement('svg')!;

      final result = RootElementConverter.fromElement(baseElement);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<vector '
          'xmlns:android="http://schemas.android.com/apk/res/android" '
          'android:width="26dp" '
          'android:height="24dp" '
          'android:viewportWidth="26.0" '
          'android:viewportHeight="24.0" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });

    test('parses the width and height attributes', () {
      final baseElement = XmlDocument.parse(
        '<svg '
        'width="48px" '
        'height="55px" '
        '/>',
      ).getElement('svg')!;

      final result = RootElementConverter.fromElement(baseElement);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<vector '
          'xmlns:android="http://schemas.android.com/apk/res/android" '
          'android:width="48dp" '
          'android:height="55dp" '
          'android:viewportWidth="48.0" '
          'android:viewportHeight="55.0" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });

    test('set width and height as -1 when input is invalid', () {
      final baseElement = XmlDocument.parse('<svg />').getElement('svg')!;

      final result = RootElementConverter.fromElement(baseElement);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<vector '
          'xmlns:android="http://schemas.android.com/apk/res/android" '
          'android:width="-1dp" '
          'android:height="-1dp" '
          'android:viewportWidth="-1.0" '
          'android:viewportHeight="-1.0" '
          '/>',
        ).toXmlString(pretty: true),
      );
    });

    test('child elements keep unchanged', () {
      final baseElement = XmlDocument.parse(
        '<svg '
        'width="26" '
        'height="24" '
        'viewBox="0 0 26 24" '
        'fill="none" '
        'xmlns="http://www.w3.org/2000/svg" '
        '>'
        '<path d="M 0.0 80.0 L 100.0 20.0"/> '
        '</svg>',
      ).getElement('svg')!;

      final result = RootElementConverter.fromElement(baseElement);

      expect(
        result.toXmlString(pretty: true),
        XmlDocument.parse(
          '<vector '
          'xmlns:android="http://schemas.android.com/apk/res/android" '
          'android:width="26dp" '
          'android:height="24dp" '
          'android:viewportWidth="26.0" '
          'android:viewportHeight="24.0" '
          '>'
          '<path d="M 0.0 80.0 L 100.0 20.0"/> '
          '</vector>',
        ).toXmlString(pretty: true),
      );
    });
  });
}

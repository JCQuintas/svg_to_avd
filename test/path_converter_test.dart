import 'package:svg_to_avd/path_converter.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('PathConverter.fromLine', () {
    test('converts a line', () {
      final element = XmlDocument.parse(
        '<line x1="0" y1="80" x2="100" y2="20" />',
      );
      final result = PathConverter.fromElement(element.getElement('line')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 0.0 80.0 L 100.0 20.0"/>',
      );
    });

    test('converts a line and maintains attributes', () {
      final element = XmlDocument.parse(
        '<line x1="0" y1="80" x2="100" y2="20" fill="blue" />',
      );
      final result = PathConverter.fromElement(element.getElement('line')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path fill="blue" d="M 0.0 80.0 L 100.0 20.0"/>',
      );
    });
  });
  group('PathConverter.fromRect', () {
    test('converts a rect with no x & y', () {
      final element = XmlDocument.parse('<rect width="100" height="100" />');
      final result = PathConverter.fromElement(element.getElement('rect')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 0.0 0.0 H 100.0 V 100.0 H 0.0 V 0.0 Z"/>',
      );
    });

    test('converts a rect with x & y', () {
      final element =
          XmlDocument.parse('<rect width="100" height="100" x="120" y="10" />');
      final result = PathConverter.fromElement(element.getElement('rect')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 120.0 10.0 H 220.0 V 110.0 H 120.0 V 10.0 Z"/>',
      );
    });

    test('converts a rect with rounded corners rx', () {
      final element = XmlDocument.parse(
        '<rect width="100" height="100" rx="15" />',
      );
      final result = PathConverter.fromElement(element.getElement('rect')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 15.0 0.0 L 85.0 0.0 Q 100.0 0.0 100.0 15.0 L 100.0 85.0 Q 100.0 100.0 85.0 100.0 L 15.0 100.0 Q 0.0 100.0 0.0 85.0 L 0.0 15.0 Q 0.0 0.0 15.0 0.0 Z"/>',
      );
    });

    test('converts a rect with rounded corners ry', () {
      final element = XmlDocument.parse(
        '<rect width="100" height="100" ry="15" />',
      );
      final result = PathConverter.fromElement(element.getElement('rect')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 15.0 0.0 L 85.0 0.0 Q 100.0 0.0 100.0 15.0 L 100.0 85.0 Q 100.0 100.0 85.0 100.0 L 15.0 100.0 Q 0.0 100.0 0.0 85.0 L 0.0 15.0 Q 0.0 0.0 15.0 0.0 Z"/>',
      );
    });

    test('converts a rect with rounded corners ry & rx', () {
      final element = XmlDocument.parse(
        '<rect width="100" height="100" ry="15" rx="5" />',
      );
      final result = PathConverter.fromElement(element.getElement('rect')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 5.0 0.0 L 95.0 0.0 Q 100.0 0.0 100.0 15.0 L 100.0 85.0 Q 100.0 100.0 95.0 100.0 L 5.0 100.0 Q 0.0 100.0 0.0 85.0 L 0.0 15.0 Q 0.0 0.0 5.0 0.0 Z"/>',
      );
    });
  });

  group('PathConverter.fromCircle', () {
    test('converts a circle', () {
      final element = XmlDocument.parse('<circle cx="50" cy="50" r="50"/>');
      final result = PathConverter.fromElement(element.getElement('circle')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 50.0 0.0 C 77.6142374915 0.0 100.0 22.3857625085 100.0 50.0 C 100.0 77.6142374915 77.6142374915 100.0 50.0 100.0 C 22.3857625085 100.0 0.0 77.6142374915 0.0 50.0 C 0.0 22.3857625085 22.3857625085 0.0 50.0 0.0 Z"/>',
      );
    });
  });

  group('PathConverter.fromEllipse', () {
    test('converts an ellipse', () {
      final element =
          XmlDocument.parse('<ellipse cx="100" cy="50" rx="100" ry="50" />');
      final result = PathConverter.fromElement(element.getElement('ellipse')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 100.0 0.0 C 155.228474983 0.0 200.0 22.3857625085 200.0 50.0 C 200.0 77.6142374915 155.228474983 100.0 100.0 100.0 C 44.7715250169 100.0 0.0 77.6142374915 0.0 50.0 C 0.0 22.3857625085 44.7715250169 0.0 100.0 0.0 Z"/>',
      );
    });
  });

  group('PathConverter.fromPoly', () {
    test('converts a polygon', () {
      final element =
          XmlDocument.parse('<polygon points="0,100 50,25 50,75 100,0" />');
      final result = PathConverter.fromElement(element.getElement('polygon')!);
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 0.0 100.0 L 50.0 25.0 L 50.0 75.0 L 100.0 0.0 Z"/>',
      );
    });
    test('converts a polyline', () {
      final element =
          XmlDocument.parse('<polyline points="0,100 50,25 50,75 100,0" />');
      final result = PathConverter.fromElement(
        element.getElement('polyline')!,
      );
      expect(
        result?.toXmlString(pretty: true),
        '<path d="M 0.0 100.0 L 50.0 25.0 L 50.0 75.0 L 100.0 0.0"/>',
      );
    });

    test('returns an empty g if points are wrong', () {
      final element = XmlDocument.parse('<polygon points="0,100 50" />');
      final result = PathConverter.fromElement(
        element.getElement('polygon')!,
      );
      expect(
        result?.toXmlString(pretty: true),
        '<g/>',
      );
    });
  });
}

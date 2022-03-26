import 'package:svg_to_avd/attribute_name.dart';
import 'package:svg_to_avd/errors/invalid_attribute_name_exception.dart';
import 'package:test/test.dart';

void main() {
  group('AttributeName.toAndroid', () {
    test('parses a valid key', () {
      expect(AttributeName.toAndroid(AttributeName.fill), 'android:fillColor');
    });

    test('throws an error on invalid key', () {
      expect(
        () => AttributeName.toAndroid('fake'),
        throwsA(
          isA<InvalidAttributeNameException>(),
        ),
      );
    });
  });
}

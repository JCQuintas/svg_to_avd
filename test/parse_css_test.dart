import 'dart:convert';

import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:test/test.dart';

import 'helpers/helpers.dart';

void main() {
  group('parseCss', () {
    test('converts the css string to a map', () {
      final result = parseCss(fixture('parse_css.css'));
      expect(
        jsonEncode(result),
        jsonEncode(jsonDecode(fixture('parse_css_result.json'))),
      );
    });
  });
}

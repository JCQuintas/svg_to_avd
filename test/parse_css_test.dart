import 'dart:convert';

import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:test/test.dart';

import 'helpers/helpers.dart';

JsonEncoder encoder = const JsonEncoder.withIndent('  ');

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

// { 
//   {
//      @media (max-width: 800px): { {}, {} }, 
//      #main #comments: { {}, {} }
//    }, 
//    {
//      margin: [0px], width: [auto], background: [red]
//    }
// }

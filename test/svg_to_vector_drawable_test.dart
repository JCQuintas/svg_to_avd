import 'package:svg_to_vector_drawable/svg_to_vector_drawable.dart';
import 'package:test/test.dart';

import 'helpers/helpers.dart';

enum Foo { bar }

void main() {
  group('svgToVectorDrawable', () {
    test('parses the use attribute', () {
      final result = svgToVectorDrawable(fixture('use.svg'));

      expect(result, fixture('use_result.svg'));
    });
  });
}

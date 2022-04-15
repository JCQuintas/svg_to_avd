import 'package:svg_to_avd/dimension_to_pixel.dart';
import 'package:test/test.dart';

class _TestCase {
  _TestCase({
    required this.unit,
    required this.result,
  });

  final String unit;
  final double result;
}

final _testCases = [
  _TestCase(unit: 'mm', result: 85.03937016),
  _TestCase(unit: 'cm', result: 850.3937016),
  _TestCase(unit: 'm', result: 85039.37015999999),
  _TestCase(unit: 'in', result: 2160),
  _TestCase(unit: 'pt', result: 30),
  _TestCase(unit: 'pc', result: 360),
  _TestCase(unit: 'ft', result: 25920),
  _TestCase(unit: 'px', result: 24),
  _TestCase(unit: '', result: 24),
];

void main() {
  group('dimensionToPixel', () {
    for (final testCase in _testCases) {
      test('parses ${testCase.unit} value', () {
        expect(dimensionToPixel('24${testCase.unit}'), testCase.result);
      });
    }
  });
}

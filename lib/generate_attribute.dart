import 'package:svg_to_vector_drawable/constants.dart';

String generateAttr(
  String name,
  String? value, {
  int groupLevel = 0,
  dynamic defaultValue,
}) {
  if (value == null || value == defaultValue) return '';
  return '${indent * (groupLevel + 2)}android:$name="$value"';
}

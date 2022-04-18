import 'dart:io';

import 'package:svg_to_avd/svg_to_avd.dart';

Future<void> main() async {
  final svg = File('file.svg').readAsStringSync();

  // Will generate an interactive XmlDocument.
  final avd = SvgToAvd.fromString(svg);

  // Creates a new file with the converted value.
  await File('file.xml').writeAsString(avd.toPrettyXmlString());
}

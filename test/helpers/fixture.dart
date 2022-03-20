import 'dart:io';
import 'package:path/path.dart';

const rootFixture = './test/helpers/fixtures';

String fixture(String name) {
  final file = File(join(rootFixture, name));
  if (!file.existsSync()) {
    throw Exception(
      'Missing fixture with name $name inside `./test/fixture` folder.',
    );
  }

  return file.readAsStringSync();
}

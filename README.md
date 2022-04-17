# svg_to_avd

[![Pub](https://img.shields.io/pub/v/svg_to_avd.svg)](https://pub.dartlang.org/packages/svg_to_avd)

Converts SVG strings into Android Vector Drawable strings. It can be used through the [CLI](#cli) or as [Code](#programmatically).

## Getting Started

This is a very simple conversion program. It does not support the full SVG specification, and specially `css` styles and the `style` attribute are completely ignored. Read more about the [Known Issues and Limitations](#known-issues-and-limitations).

### Programmatically

Install the library using your preferred method.

```bash
dart pub add svg_to_avd
```

Then use the library, the `SvgToAvd` class only exposes a single constructor to build AVDs from string, `SvgToAvd.fromString`.

```dart
import 'package:svg_to_avd/svg_to_avd.dart';

final svg = File('file.svg').readAsStringSync();

// Will generate an interactive XmlDocument.
final avd = SvgToAvd.fromString(svg);

// Creates a new file with the converted value
await File('file.xml').writeAsString(avd.toPrettyXmlString());
```

> This library is not responsible for reading or writing files, and the user should do it themselves.

### Cli

To make the binary available to be run directly, first you need to active it globally.

```bash
dart pub global activate svg_to_avd
```

Then you will be able to run it using both `svg_to_avd` or `svgtoavd`.

**Common** usage:

```bash
svgtoavd file.svg
```

**Piping** usage:

```bash
cat file.svg | svgtoavd
```

#### Cli Options

| option   | alias | description                                               |
| -------- | ----- | --------------------------------------------------------- |
| --help   | -h    | displays help                                             |
| --output | -o    | The XML file to be created. Prints to console if not set. |

## Known Issues and Limitations

There are a few known issues and limitations that weren't necessary for the use-case this library was created. While they were not initially implemented, any Pull Request will be appreciated. If a missing feature is really important to you, please create an issue with your use case.

### Css

No `css` is supported. It is quite complex to parse all the available options and then put them on the correct elements.

### Style

The `style` attribute is also not supported for the same reasons as the css, though it is technically a bit simpler.

### Named Colors

We currently don't support named colors. Should be simple to add it though.

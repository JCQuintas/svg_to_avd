import 'package:svg_to_vector_drawable/constants.dart';
import 'package:svg_to_vector_drawable/parse_css.dart';
import 'package:svg_to_vector_drawable/replace_use_tags.dart';
import 'package:svg_to_vector_drawable/svg_dimension.dart';
import 'package:xml/xml.dart';

// const _drawLine = 'l';
// const _startPath = 'M';
// const _endPath = 'Z';

/// Converts the [xmlString] into a Vector Drawable.
String svgToVectorDrawable(String xmlString) {
  final buffer = StringBuffer();
  final document = XmlDocument.parse(xmlString);

  final globalSvg = document.getElement('svg');

  if (globalSvg == null) return '';

  replaceUseTags(globalSvg);

  final style = globalSvg.getElement('svg');
  final hasStyle = style != null && style.text.isNotEmpty;

  final svgStyles =
      hasStyle ? parseCss(style.text.trim(), splitSelectors: true) : null;

  final dimensions = SvgDimension.parse(globalSvg);

  buffer
    ..writeln('<?xml version="1.0" encoding="utf-8"?>')
    ..writeln(
      '<vector xmlns:android="http://schemas.android.com/apk/res/android"',
    )
    ..writeln('${indent}android:width="${dimensions.width}dp')
    ..writeln('${indent}android:height="${dimensions.height}dp')
    ..writeln('${indent}android:viewportWidth="${dimensions.width}"')
    ..writeln('${indent}android:viewportHeight="${dimensions.height}"')
    ..writeln('>')
    ..writeln()
    ..writeln();

  print('');

  buffer
    ..writeln()
    ..writeln()
    ..writeln('</vector>');

  // return
  return globalSvg.toXmlString(pretty: true);
}

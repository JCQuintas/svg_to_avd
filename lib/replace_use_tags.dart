import 'package:xml/xml.dart';

/// Receives a [svg] and replaces all the <use> tags into the elements
/// that they reference. This changes [svg] in place.
void replaceUseTags(XmlElement svg) {
  svg.descendantElements.where((e) => e.name.local == 'use').forEach((element) {
    final href = element.getAttribute('xlink:href')?.trim() ??
        element.getAttribute('href')?.trim();

    if (href == null || href.isEmpty || !href.startsWith('#')) return;

    final reference = svg.descendantElements.where(
      (node) => node.attributes.any(
        (attribute) =>
            attribute.name.local == 'id' &&
            attribute.value == href.substring(1),
      ),
    );

    if (reference.isEmpty) return;

    final clone = reference.first.copy();

    for (final attribute in element.attributes) {
      clone.setAttribute(
        attribute.name.qualified,
        attribute.value,
      );
    }

    clone
      ..removeAttribute('href')
      ..removeAttribute('xlink:href')
      ..removeAttribute('id');

    element.replace(clone);
  });
}

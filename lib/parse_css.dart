final _commentX = RegExp(r'\/\*[\s\S]*?\*\/');
final _lineAttrX = RegExp(r'(?<name>[^\:]+):(?<value>[^\;]*);');
final _altX = RegExp(
  r'(?<comment>\/\*[\s\S]*?\*\/)|(?<selector>[^\s\;\{\}][^\;\{\}]*(?=\{))|(?<end>\})|(?<attribute>[^\;\{\}]+\;(?!\s*\*\/))',
  caseSensitive: false,
  multiLine: true,
);

const _selector = 'selector';
const _end = 'end';
const _attribute = 'attribute';
const _name = 'name';
const _value = 'value';

typedef Attributes = Map<String, String>;
typedef Children = Map<String, CssMap>;

class CssMap {
  CssMap({required this.children, required this.attributes});

  final Children children;
  final Attributes attributes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'children': children,
        'attributes': attributes,
      };
}

/// Receives a string containing [cssString] and returns a [Map] of the parsed
/// nodes.
CssMap parseCss(
  String cssString, {
  bool splitSelectors = false,
  List<int>? startIndex,
}) {
  final internalIndex = startIndex ?? [0];

  final node = CssMap(children: {}, attributes: {});

  final workCssString = cssString.replaceAll(_commentX, '');
  var match = _altX.allMatches(workCssString, internalIndex.first);

  while (match.isNotEmpty) {
    internalIndex.replaceRange(0, 1, [match.first.end]);
    final selectorValue = match.first.namedGroup(_selector)?.trim();
    final endValue = match.first.namedGroup(_end)?.trim();
    final attributeValue = match.first.namedGroup(_attribute)?.trim();

    if (selectorValue != null) {
      // Found new selector, parse node
      final name = selectorValue;
      final newNode = parseCss(
        workCssString,
        splitSelectors: splitSelectors,
        startIndex: internalIndex,
      );
      final selectors = splitSelectors
          ? name.split(',').map((e) => e.trim()).toList()
          : [name];

      for (final selector in selectors) {
        if (node.children.containsKey(selector)) {
          for (final attribute in newNode.attributes.keys) {
            final newAttribute = newNode.attributes[attribute];
            if (newAttribute != null) {
              node.children[selector]?.attributes[attribute] = newAttribute;
            }
          }
        } else {
          node.children[selector] = newNode;
        }
      }
    } else if (endValue != null) {
      // Node has finished, return it
      return node;
    } else if (attributeValue != null) {
      // Attribute needs to be split by name and value and stored
      final line = attributeValue;
      final attribute = _lineAttrX.firstMatch(line);
      final name = attribute?.namedGroup(_name)?.trim();
      final value = attribute?.namedGroup(_value)?.trim();

      if (name != null && value != null) {
        node.attributes[name] = value;
      }
    }

    match = _altX.allMatches(workCssString, internalIndex.first);
  }

  return node;
}

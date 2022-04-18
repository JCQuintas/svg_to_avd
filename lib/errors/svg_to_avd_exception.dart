/// Default implementation of [SvgToAvdException] which carries a message
/// and prints the class name when calling toString.
abstract class SvgToAvdException implements Exception {
  /// Public constructor.
  SvgToAvdException(this._message);

  final String _message;

  // ignore: format-comment, no need to add toString in coverage.
  // coverage:ignore-start
  @override
  String toString() {
    // ignore: no_runtimetype_tostring, prefer error clarity over performance.
    return '$runtimeType: $_message';
  }
  // ignore: format-comment, end ignore.
  // coverage:ignore-end
}

class SvgToAvdException implements Exception {
  SvgToAvdException(this.message);

  final String message;

  // ignore: format-comment, no need to add toString in coverage.
  // coverage:ignore-start
  @override
  String toString() {
    // ignore: no_runtimetype_tostring, prefer error clarity over performance.
    return '$runtimeType: $message';
  }
  // ignore: format-comment, end ignore.
  // coverage:ignore-end
}

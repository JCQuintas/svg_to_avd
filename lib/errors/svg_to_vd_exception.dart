class SvgToVdException implements Exception {
  SvgToVdException(this.message);

  final String message;

  // coverage:ignore-start no need to add toString in coverage
  @override
  String toString() {
    // ignore: no_runtimetype_tostring
    return '$runtimeType: $message';
  }
  // coverage:ignore-end
}

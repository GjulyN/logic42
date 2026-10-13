class GenerationFailure implements Exception {
  GenerationFailure(this.message);
  final String message;
  @override
  String toString() => 'GenerationFailure: $message';
}

class TokenRefreshFailedException implements Exception {
  final String message;

  TokenRefreshFailedException([
    this.message = "No se pudo refrescar el token.",
  ]);

  @override
  String toString() => 'TokenRefreshFailedException: $message';
}

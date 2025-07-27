final _errorMap = {
  // Errores de conexión más comunes
  "connection timeout":
      "No se pudo conectar. Revisa tu conexión o intenta más tarde.",
  "receive timeout": "El servidor no responde. Intenta más tarde.",
  "send timeout": "No se pudo enviar la información. Intenta más tarde.",
  "socket exception": "Sin conexión a internet. Revisa tu conexión.",
  "network is unreachable": "Sin conexión a internet. Revisa tu conexión.",
  "connection error": "Sin conexión a internet. Revisa tu conexión.",
  "connection refused": "Sin conexión a internet. Revisa tu conexión.",

  // Errores HTTP más relevantes para el usuario
  "401": "Credenciales incorrectas o sesión expirada.",
  "403": "No tienes permisos para realizar esta acción.",
  "404": "Recurso no encontrado.",
  "422": "Los datos ingresados no son válidos.",
  "429": "Demasiadas solicitudes. Intenta más tarde.",
  "500": "Error del servidor. Intenta más tarde.",
  "502": "Servicio no disponible. Intenta más tarde.",
  "503": "Servicio no disponible. Intenta más tarde.",

  // Errores de autenticación específicos
  "Correo o contraseña incorrecta": "Correo o contraseña incorrecta.",
  "unauthorized": "Credenciales incorrectas o sesión expirada.",
  "token expired": "Sesión expirada. Inicia sesión nuevamente.",

  // Solicitud cancelada
  "request cancelled": "Operación cancelada.",
  "request canceled": "Operación cancelada.",
};

String _getFriendlyErrorMessage(String rawError) {
  String error = rawError.replaceAll("Exception: ", "").toLowerCase();
  String? bestMatch;
  int bestMatchLength = 0;

  for (final entry in _errorMap.entries) {
    String key = entry.key.toLowerCase();
    if (error.contains(key) && key.length > bestMatchLength) {
      bestMatch = entry.value;
      bestMatchLength = key.length;
    }
  }

  // Mensaje genérico para errores técnicos no mapeados
  return bestMatch ?? "Algo salió mal. Intenta nuevamente.";
}

class ErrorHelper {
  static String getFriendlyErrorMessage(String rawError) =>
      _getFriendlyErrorMessage(rawError);
}

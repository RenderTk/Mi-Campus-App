class EmailValidator {
  // Patrón regex de correo electrónico similar al de Pydantic's EmailStr
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Valida el formato del correo electrónico
  /// Retorna null si es válido, o un mensaje de error si no lo es
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Correo obligatorio';
    }

    final trimmedValue = value.trim();

    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Correo inválido';
    }

    if (trimmedValue.length > 254) {
      return 'Correo muy largo';
    }

    if (trimmedValue.contains('..')) {
      return 'No se permiten ".."';
    }

    if (trimmedValue.startsWith('.') || trimmedValue.endsWith('.')) {
      return 'No puede empezar o terminar en punto';
    }

    final parts = trimmedValue.split('@');
    if (parts.length != 2) {
      return 'Correo inválido';
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    if (localPart.isEmpty || localPart.length > 64) {
      return 'Parte local inválida';
    }

    if (domainPart.isEmpty || domainPart.length > 253) {
      return 'Dominio inválido';
    }

    if (domainPart.startsWith('-') || domainPart.endsWith('-')) {
      return 'Dominio mal formado';
    }
    return null;
  }

  /// Validador de correo institucional (puedes personalizar los dominios)
  static String? validateInstitutional(
    String? value, {
    List<String>? allowedDomains,
  }) {
    final basicValidation = validate(value);
    if (basicValidation != null) {
      return basicValidation;
    }

    if (allowedDomains != null && allowedDomains.isNotEmpty) {
      final email = value!.trim().toLowerCase();
      final domain = email.split('@')[1];

      bool isAllowed = false;
      for (String allowedDomain in allowedDomains) {
        String lowerDomain = allowedDomain.toLowerCase();
        if (domain == lowerDomain || domain.endsWith('.$lowerDomain')) {
          isAllowed = true;
          break;
        }
      }

      if (!isAllowed) {
        return 'Usa un correo institucional';
      }
    }
    return null;
  }
}

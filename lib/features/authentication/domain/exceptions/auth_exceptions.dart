/// Clase base para todas las excepciones de autenticación
///
/// Proporciona una estructura común para manejar errores relacionados
/// con la autenticación en la aplicación.
abstract class AuthException implements Exception {
  /// Mensaje de error técnico
  final String message;

  /// Código de error para identificación programática
  final String code;

  /// Mensaje de error amigable para el usuario
  final String userMessage;

  const AuthException({
    required this.message,
    required this.code,
    required this.userMessage,
  });

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}

/// Excepción para credenciales inválidas
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    super.message = 'Invalid email or password',
    super.code = 'invalid-credentials',
    super.userMessage = 'Email o contraseña incorrectos',
  });
}

/// Excepción para email no verificado
class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException({
    super.message = 'Email not verified',
    super.code = 'email-not-verified',
    super.userMessage = 'Por favor verifica tu email antes de continuar',
  });
}

/// Excepción para usuario no encontrado
class UserNotFoundException extends AuthException {
  const UserNotFoundException({
    super.message = 'User not found',
    super.code = 'user-not-found',
    super.userMessage = 'No se encontró un usuario con este email',
  });
}

/// Excepción para email ya en uso
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException({
    super.message = 'Email already in use',
    super.code = 'email-already-in-use',
    super.userMessage = 'Este email ya está registrado',
  });
}

/// Excepción para contraseña débil
class WeakPasswordException extends AuthException {
  const WeakPasswordException({
    super.message = 'Weak password',
    super.code = 'weak-password',
    super.userMessage = 'La contraseña debe tener al menos 6 caracteres',
  });
}

/// Excepción para demasiados intentos
class TooManyRequestsException extends AuthException {
  const TooManyRequestsException({
    super.message = 'Too many requests',
    super.code = 'too-many-requests',
    super.userMessage = 'Demasiados intentos. Intenta de nuevo más tarde',
  });
}

/// Excepción para cuenta deshabilitada
class UserDisabledException extends AuthException {
  const UserDisabledException({
    super.message = 'User account disabled',
    super.code = 'user-disabled',
    super.userMessage = 'Esta cuenta ha sido deshabilitada',
  });
}

/// Excepción para operación no permitida
class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException({
    super.message = 'Operation not allowed',
    super.code = 'operation-not-allowed',
    super.userMessage = 'Esta operación no está permitida',
  });
}

/// Excepción para falta de permisos
class InsufficientPermissionsException extends AuthException {
  const InsufficientPermissionsException({
    super.message = 'Insufficient permissions',
    super.code = 'insufficient-permissions',
    super.userMessage = 'No tienes permisos para realizar esta acción',
  });
}

/// Excepción para sesión expirada
class SessionExpiredException extends AuthException {
  const SessionExpiredException({
    super.message = 'Session expired',
    super.code = 'session-expired',
    super.userMessage = 'Tu sesión ha expirado. Inicia sesión nuevamente',
  });
}

/// Excepción para errores de red
class NetworkException extends AuthException {
  const NetworkException({
    super.message = 'Network error',
    super.code = 'network-error',
    super.userMessage = 'Error de conexión. Verifica tu internet',
  });
}

/// Excepción para errores del servidor
class ServerException extends AuthException {
  const ServerException({
    super.message = 'Server error',
    super.code = 'server-error',
    super.userMessage = 'Error del servidor. Intenta más tarde',
  });
}

/// Excepción genérica para errores desconocidos
class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    super.message = 'Unknown authentication error',
    super.code = 'unknown-error',
    super.userMessage = 'Ocurrió un error inesperado',
  });
}

/// Utilidad para convertir códigos de error de Firebase a excepciones personalizadas
class AuthExceptionMapper {
  static AuthException fromFirebaseAuthCode(String code, [String? message]) {
    switch (code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'invalid-credential':
        return InvalidCredentialsException(message: message ?? code);

      case 'user-not-found':
        return UserNotFoundException(message: message ?? code);

      case 'email-already-in-use':
        return EmailAlreadyInUseException(message: message ?? code);

      case 'weak-password':
        return WeakPasswordException(message: message ?? code);

      case 'too-many-requests':
        return TooManyRequestsException(message: message ?? code);

      case 'user-disabled':
        return UserDisabledException(message: message ?? code);

      case 'operation-not-allowed':
        return OperationNotAllowedException(message: message ?? code);

      case 'network-request-failed':
        return NetworkException(message: message ?? code);

      case 'internal-error':
        return ServerException(message: message ?? code);

      default:
        return UnknownAuthException(
          message: message ?? 'Unknown error: $code',
          code: code,
        );
    }
  }

  /// Convierte una excepción genérica a AuthException
  static AuthException fromException(Object error) {
    if (error is AuthException) {
      return error;
    }

    if (error is Exception) {
      return UnknownAuthException(message: error.toString());
    }

    return UnknownAuthException(message: 'Unknown error: $error');
  }
}

/// Excepciones específicas para validación de entrada
class ValidationException extends AuthException {
  const ValidationException({
    required super.message,
    required super.code,
    required super.userMessage,
  });
}

/// Excepción para email inválido
class InvalidEmailFormatException extends ValidationException {
  const InvalidEmailFormatException({
    super.message = 'Invalid email format',
    super.code = 'invalid-email-format',
    super.userMessage = 'Por favor ingresa un email válido',
  });
}

/// Excepción para contraseña muy corta
class PasswordTooShortException extends ValidationException {
  const PasswordTooShortException({
    super.message = 'Password too short',
    super.code = 'password-too-short',
    super.userMessage = 'La contraseña debe tener al menos 6 caracteres',
  });
}

/// Excepción para campos requeridos
class RequiredFieldException extends ValidationException {
  final String fieldName;

  const RequiredFieldException({
    required this.fieldName,
    String? message,
    super.code = 'required-field',
    String? userMessage,
  }) : super(
         message: message ?? 'Field $fieldName is required',
         userMessage: userMessage ?? 'El campo $fieldName es requerido',
       );
}

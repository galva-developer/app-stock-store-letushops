import '../../entities/auth_user.dart';
import '../../repositories/auth_repository.dart';

/// Caso de uso para registrar nuevos usuarios (solo administradores)
///
/// Este caso de uso permite a los administradores crear nuevas cuentas
/// de usuario con roles específicos (Employee o Manager).
///
/// Características:
/// - Solo accesible para usuarios con rol Admin
/// - Asigna roles durante la creación
/// - Crea usuario en Firebase Auth y Firestore
/// - Envía email de verificación automáticamente
/// - Valida permisos antes de crear
///
/// Ejemplo de uso:
/// ```dart
/// final user = await registerUserUseCase(
///   email: 'nuevo@letushops.com',
///   password: 'Temporal123!',
///   displayName: 'Juan Pérez',
///   role: UserRole.employee,
/// );
/// ```
class RegisterUserUseCase {
  final AuthRepository _repository;

  RegisterUserUseCase(this._repository);

  /// Registra un nuevo usuario en el sistema
  ///
  /// [email] Email del nuevo usuario (debe ser único)
  /// [password] Contraseña temporal (mínimo 8 caracteres)
  /// [displayName] Nombre completo del usuario
  /// [role] Rol asignado (employee o manager)
  ///
  /// Returns: El usuario creado con todos sus datos
  ///
  /// Throws:
  /// - [InsufficientPermissionsException] Si el usuario actual no es admin
  /// - [EmailAlreadyInUseException] Si el email ya está registrado
  /// - [WeakPasswordException] Si la contraseña no cumple requisitos
  /// - [AuthException] Para otros errores de autenticación
  Future<AuthUser> call({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    return await _repository.registerUser(
      email: email,
      password: password,
      displayName: displayName,
      role: role,
    );
  }
}

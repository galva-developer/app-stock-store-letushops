import '../../entities/auth_user.dart';
import '../../repositories/auth_repository.dart';

/// Caso de uso para actualizar el estado de un usuario
///
/// Este caso de uso permite a los administradores cambiar el estado
/// de cualquier usuario (activo, suspendido, inactivo).
///
/// Requiere permisos de administrador.
class UpdateUserStatusUseCase {
  final AuthRepository _repository;

  UpdateUserStatusUseCase(this._repository);

  /// Ejecuta el caso de uso
  ///
  /// Parameters:
  /// - [userId]: ID del usuario a actualizar
  /// - [newStatus]: Nuevo estado a asignar
  ///
  /// Throws:
  /// - AuthException si hay un error al actualizar el estado
  /// - PermissionDeniedException si el usuario no tiene permisos de admin
  Future<void> call({
    required String userId,
    required UserStatus newStatus,
  }) async {
    return await _repository.updateUserStatus(
      userId: userId,
      newStatus: newStatus,
    );
  }
}

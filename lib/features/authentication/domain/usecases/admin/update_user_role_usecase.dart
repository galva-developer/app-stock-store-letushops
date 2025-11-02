import '../../entities/auth_user.dart';
import '../../repositories/auth_repository.dart';

/// Caso de uso para actualizar el rol de un usuario
///
/// Este caso de uso permite a los administradores cambiar el rol
/// de cualquier usuario en el sistema.
///
/// Requiere permisos de administrador.
class UpdateUserRoleUseCase {
  final AuthRepository _repository;

  UpdateUserRoleUseCase(this._repository);

  /// Ejecuta el caso de uso
  ///
  /// Parameters:
  /// - [userId]: ID del usuario a actualizar
  /// - [newRole]: Nuevo rol a asignar
  ///
  /// Throws:
  /// - AuthException si hay un error al actualizar el rol
  /// - PermissionDeniedException si el usuario no tiene permisos de admin
  Future<void> call({required String userId, required UserRole newRole}) async {
    return await _repository.updateUserRole(userId: userId, newRole: newRole);
  }
}

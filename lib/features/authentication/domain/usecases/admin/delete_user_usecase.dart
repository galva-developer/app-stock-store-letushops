import '../../repositories/auth_repository.dart';

/// Caso de uso para eliminar un usuario del sistema
///
/// Este caso de uso permite a los administradores eliminar
/// permanentemente un usuario de la aplicación.
///
/// Requiere permisos de administrador.
class DeleteUserUseCase {
  final AuthRepository _repository;

  DeleteUserUseCase(this._repository);

  /// Ejecuta el caso de uso
  ///
  /// Parameters:
  /// - [userId]: ID del usuario a eliminar
  ///
  /// Throws:
  /// - AuthException si hay un error al eliminar el usuario
  /// - PermissionDeniedException si el usuario no tiene permisos de admin
  Future<void> call({required String userId}) async {
    return await _repository.deleteUser(userId: userId);
  }
}

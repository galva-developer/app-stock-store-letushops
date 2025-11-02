import '../../entities/auth_user.dart';
import '../../repositories/auth_repository.dart';

/// Caso de uso para listar todos los usuarios del sistema
///
/// Este caso de uso permite a los administradores obtener la lista
/// completa de usuarios registrados en la aplicación.
///
/// Requiere permisos de administrador.
class ListAllUsersUseCase {
  final AuthRepository _repository;

  ListAllUsersUseCase(this._repository);

  /// Ejecuta el caso de uso
  ///
  /// Returns:
  /// - Lista de todos los usuarios del sistema
  ///
  /// Throws:
  /// - AuthException si hay un error al obtener los usuarios
  /// - PermissionDeniedException si el usuario no tiene permisos de admin
  Future<List<AuthUser>> call() async {
    return await _repository.getAllUsers();
  }
}

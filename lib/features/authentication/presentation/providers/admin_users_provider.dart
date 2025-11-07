import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/admin/list_all_users_usecase.dart';
import '../../domain/usecases/admin/update_user_role_usecase.dart';
import '../../domain/usecases/admin/update_user_status_usecase.dart';
import '../../domain/usecases/admin/delete_user_usecase.dart';
import '../../domain/usecases/admin/register_user_usecase.dart';
import '../../domain/exceptions/auth_exceptions.dart';

/// Estados del provider de administración de usuarios
enum AdminUsersState { initial, loading, loaded, error, updating, deleting }

/// Provider para la gestión de usuarios por parte de administradores
///
/// Este provider maneja todas las operaciones de administración de usuarios:
/// - Listar usuarios
/// - Registrar nuevos usuarios
/// - Actualizar roles
/// - Actualizar estados
/// - Eliminar usuarios
/// - Búsqueda y filtrado
class AdminUsersProvider extends ChangeNotifier {
  final ListAllUsersUseCase _listAllUsersUseCase;
  final UpdateUserRoleUseCase _updateUserRoleUseCase;
  final UpdateUserStatusUseCase _updateUserStatusUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final RegisterUserUseCase _registerUserUseCase;

  AdminUsersProvider({
    required ListAllUsersUseCase listAllUsersUseCase,
    required UpdateUserRoleUseCase updateUserRoleUseCase,
    required UpdateUserStatusUseCase updateUserStatusUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required RegisterUserUseCase registerUserUseCase,
  }) : _listAllUsersUseCase = listAllUsersUseCase,
       _updateUserRoleUseCase = updateUserRoleUseCase,
       _updateUserStatusUseCase = updateUserStatusUseCase,
       _deleteUserUseCase = deleteUserUseCase,
       _registerUserUseCase = registerUserUseCase;

  // Estado del provider
  AdminUsersState _state = AdminUsersState.initial;
  AdminUsersState get state => _state;

  // Lista de usuarios
  List<AuthUser> _users = [];
  List<AuthUser> get users => _users;

  // Lista filtrada de usuarios
  List<AuthUser> _filteredUsers = [];
  List<AuthUser> get filteredUsers => _filteredUsers;

  // Mensaje de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Filtros
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  UserRole? _roleFilter;
  UserRole? get roleFilter => _roleFilter;

  UserStatus? _statusFilter;
  UserStatus? get statusFilter => _statusFilter;

  /// Carga todos los usuarios del sistema
  Future<void> loadUsers() async {
    try {
      _state = AdminUsersState.loading;
      _errorMessage = null;
      notifyListeners();

      _users = await _listAllUsersUseCase();
      _applyFilters();

      _state = AdminUsersState.loaded;
      notifyListeners();
    } on InsufficientPermissionsException {
      _errorMessage = 'No tienes permisos para ver los usuarios';
      _state = AdminUsersState.error;
      notifyListeners();
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
      _state = AdminUsersState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar usuarios: ${e.toString()}';
      _state = AdminUsersState.error;
      notifyListeners();
    }
  }

  /// Actualiza el rol de un usuario
  Future<bool> updateUserRole({
    required String userId,
    required UserRole newRole,
  }) async {
    try {
      _state = AdminUsersState.updating;
      notifyListeners();

      await _updateUserRoleUseCase(userId: userId, newRole: newRole);

      // Actualizar localmente
      final index = _users.indexWhere((user) => user.uid == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(role: newRole);
        _applyFilters();
      }

      _state = AdminUsersState.loaded;
      notifyListeners();
      return true;
    } on InsufficientPermissionsException {
      _errorMessage = 'No tienes permisos para cambiar roles';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar rol: ${e.toString()}';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    }
  }

  /// Actualiza el estado de un usuario
  Future<bool> updateUserStatus({
    required String userId,
    required UserStatus newStatus,
  }) async {
    try {
      _state = AdminUsersState.updating;
      notifyListeners();

      await _updateUserStatusUseCase(userId: userId, newStatus: newStatus);

      // Actualizar localmente
      final index = _users.indexWhere((user) => user.uid == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(status: newStatus);
        _applyFilters();
      }

      _state = AdminUsersState.loaded;
      notifyListeners();
      return true;
    } on InsufficientPermissionsException {
      _errorMessage = 'No tienes permisos para cambiar estados';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar estado: ${e.toString()}';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    }
  }

  /// Elimina un usuario del sistema
  Future<bool> deleteUser({required String userId}) async {
    try {
      _state = AdminUsersState.deleting;
      notifyListeners();

      await _deleteUserUseCase(userId: userId);

      // Remover localmente
      _users.removeWhere((user) => user.uid == userId);
      _applyFilters();

      _state = AdminUsersState.loaded;
      notifyListeners();
      return true;
    } on InsufficientPermissionsException {
      _errorMessage = 'No tienes permisos para eliminar usuarios';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error al eliminar usuario: ${e.toString()}';
      _state = AdminUsersState.error;
      notifyListeners();
      return false;
    }
  }

  /// Actualiza la búsqueda de usuarios
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  /// Actualiza el filtro de rol
  void setRoleFilter(UserRole? role) {
    _roleFilter = role;
    _applyFilters();
    notifyListeners();
  }

  /// Actualiza el filtro de estado
  void setStatusFilter(UserStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _searchQuery = '';
    _roleFilter = null;
    _statusFilter = null;
    _applyFilters();
    notifyListeners();
  }

  /// Aplica los filtros a la lista de usuarios
  void _applyFilters() {
    _filteredUsers =
        _users.where((user) {
          // Filtro de búsqueda
          if (_searchQuery.isNotEmpty) {
            final matchesEmail = user.email.toLowerCase().contains(
              _searchQuery,
            );
            final matchesName =
                user.displayName?.toLowerCase().contains(_searchQuery) ?? false;
            if (!matchesEmail && !matchesName) return false;
          }

          // Filtro de rol
          if (_roleFilter != null && user.role != _roleFilter) {
            return false;
          }

          // Filtro de estado
          if (_statusFilter != null && user.status != _statusFilter) {
            return false;
          }

          return true;
        }).toList();

    // Ordenar por email
    _filteredUsers.sort((a, b) => a.email.compareTo(b.email));
  }

  /// Obtiene estadísticas de usuarios
  Map<String, int> get statistics {
    return {
      'total': _users.length,
      'active': _users.where((u) => u.status == UserStatus.active).length,
      'suspended': _users.where((u) => u.status == UserStatus.suspended).length,
      'inactive': _users.where((u) => u.status == UserStatus.inactive).length,
      'admins': _users.where((u) => u.role == UserRole.admin).length,
      'managers': _users.where((u) => u.role == UserRole.manager).length,
      'employees': _users.where((u) => u.role == UserRole.employee).length,
    };
  }

  /// Limpia el mensaje de error
  void clearError() {
    _errorMessage = null;
    if (_state == AdminUsersState.error) {
      _state = AdminUsersState.loaded;
    }
    notifyListeners();
  }

  /// Registra un nuevo usuario en el sistema
  ///
  /// Solo los administradores pueden ejecutar esta operación.
  /// El usuario se crea con estado activo y recibe un email de verificación.
  ///
  /// Parameters:
  /// - [email] Email único del nuevo usuario
  /// - [password] Contraseña temporal (mínimo 8 caracteres)
  /// - [displayName] Nombre completo del usuario
  /// - [role] Rol asignado (employee o manager)
  ///
  /// Returns: true si se registró exitosamente, false en caso de error
  Future<bool> registerUser({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      _state = AdminUsersState.updating;
      _errorMessage = null;
      notifyListeners();

      // Ejecutar caso de uso
      await _registerUserUseCase(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );

      // Recargar lista de usuarios
      await loadUsers();

      _state = AdminUsersState.loaded;
      notifyListeners();

      return true;
    } on AuthException catch (e) {
      _state = AdminUsersState.error;
      _errorMessage = e.userMessage;
      notifyListeners();
      return false;
    } catch (e) {
      _state = AdminUsersState.error;
      _errorMessage = 'Error inesperado al registrar usuario';
      notifyListeners();
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/auth_user.dart';
import '../../providers/admin_users_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/admin/user_list_item.dart';
import '../../widgets/admin/register_user_dialog.dart';

/// Pantalla de administración de usuarios
///
/// Permite a los administradores:
/// - Ver lista de todos los usuarios
/// - Cambiar roles de usuarios
/// - Cambiar estados de usuarios
/// - Eliminar usuarios
/// - Filtrar y buscar usuarios
class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar usuarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUsersProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminUsersProvider>().loadUsers();
            },
            tooltip: 'Recargar',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Consumer<AdminUsersProvider>(
        builder: (context, provider, child) {
          if (provider.state == AdminUsersState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == AdminUsersState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'Error desconocido',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadUsers(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Estadísticas
              _buildStatisticsPanel(context, provider),

              // Barra de búsqueda
              _buildSearchBar(context, provider),

              // Lista de usuarios
              Expanded(
                child:
                    provider.filteredUsers.isEmpty
                        ? _buildEmptyState(context)
                        : _buildUsersList(context, provider, isTablet),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegisterDialog(context),
        backgroundColor: const Color(0xFFD32F2F),
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }

  Widget _buildStatisticsPanel(
    BuildContext context,
    AdminUsersProvider provider,
  ) {
    final stats = provider.statistics;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          isTablet
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Total',
                    stats['total']!,
                    Icons.people,
                    Colors.white,
                  ),
                  _buildStatCard(
                    'Activos',
                    stats['active']!,
                    Icons.check_circle,
                    Colors.green.shade300,
                  ),
                  _buildStatCard(
                    'Suspendidos',
                    stats['suspended']!,
                    Icons.pause_circle,
                    Colors.orange.shade300,
                  ),
                  _buildStatCard(
                    'Admins',
                    stats['admins']!,
                    Icons.admin_panel_settings,
                    Colors.red.shade300,
                  ),
                  _buildStatCard(
                    'Managers',
                    stats['managers']!,
                    Icons.manage_accounts,
                    Colors.blue.shade300,
                  ),
                ],
              )
              : Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatCard(
                    'Total',
                    stats['total']!,
                    Icons.people,
                    Colors.white,
                    compact: true,
                  ),
                  _buildStatCard(
                    'Activos',
                    stats['active']!,
                    Icons.check_circle,
                    Colors.green.shade300,
                    compact: true,
                  ),
                  _buildStatCard(
                    'Suspendidos',
                    stats['suspended']!,
                    Icons.pause_circle,
                    Colors.orange.shade300,
                    compact: true,
                  ),
                  _buildStatCard(
                    'Admins',
                    stats['admins']!,
                    Icons.admin_panel_settings,
                    Colors.red.shade300,
                    compact: true,
                  ),
                ],
              ),
    );
  }

  Widget _buildStatCard(
    String label,
    int value,
    IconData icon,
    Color iconColor, {
    bool compact = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: compact ? 20 : 24),
          SizedBox(width: compact ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 18 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: compact ? 10 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AdminUsersProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por email o nombre...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                    },
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          provider.setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No se encontraron usuarios',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchController.clear();
              context.read<AdminUsersProvider>().clearFilters();
            },
            child: const Text('Limpiar filtros'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    AdminUsersProvider provider,
    bool isTablet,
  ) {
    final currentUser = context.read<AuthProvider>().currentUser;

    return RefreshIndicator(
      onRefresh: () => provider.loadUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: provider.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = provider.filteredUsers[index];
          final isCurrentUser = user.uid == currentUser?.uid;

          return UserListItem(
            user: user,
            isCurrentUser: isCurrentUser,
            onRoleChanged: (newRole) async {
              final success = await provider.updateUserRole(
                userId: user.uid,
                newRole: newRole,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Rol actualizado a ${newRole.displayName}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            onStatusChanged: (newStatus) async {
              final success = await provider.updateUserStatus(
                userId: user.uid,
                newStatus: newStatus,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Estado actualizado a ${newStatus.displayName}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            onDelete: () async {
              final success = await provider.deleteUser(userId: user.uid);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario eliminado'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    final provider = context.read<AdminUsersProvider>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filtros'),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rol',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: provider.roleFilter == null,
                        onSelected: (_) => provider.setRoleFilter(null),
                      ),
                      ...UserRole.values.map(
                        (role) => FilterChip(
                          label: Text(role.displayName),
                          selected: provider.roleFilter == role,
                          onSelected: (_) => provider.setRoleFilter(role),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estado',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: provider.statusFilter == null,
                        onSelected: (_) => provider.setStatusFilter(null),
                      ),
                      ...UserStatus.values.map(
                        (status) => FilterChip(
                          label: Text(status.displayName),
                          selected: provider.statusFilter == status,
                          onSelected: (_) => provider.setStatusFilter(status),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  provider.clearFilters();
                  Navigator.of(context).pop();
                },
                child: const Text('Limpiar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aplicar'),
              ),
            ],
          ),
    );
  }

  /// Muestra el diálogo para registrar un nuevo usuario
  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => RegisterUserDialog(
            onRegister: ({
              required email,
              required password,
              required displayName,
              required role,
            }) async {
              final provider = context.read<AdminUsersProvider>();
              return await provider.registerUser(
                email: email,
                password: password,
                displayName: displayName,
                role: role,
              );
            },
          ),
    );
  }
}

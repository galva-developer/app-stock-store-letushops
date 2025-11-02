import 'package:flutter/material.dart';
import '../../../domain/entities/auth_user.dart';
import 'user_status_badge.dart';
import 'user_role_selector.dart';

/// Widget que representa un elemento de usuario en la lista de administración
class UserListItem extends StatelessWidget {
  final AuthUser user;
  final Function(UserRole) onRoleChanged;
  final Function(UserStatus) onStatusChanged;
  final VoidCallback onDelete;
  final bool isCurrentUser;

  const UserListItem({
    super.key,
    required this.user,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onDelete,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isCurrentUser
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con avatar y nombre
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: isTablet ? 30 : 24,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  backgroundImage:
                      user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                  child:
                      user.photoURL == null
                          ? Icon(
                            Icons.person,
                            size: isTablet ? 32 : 24,
                            color: Theme.of(context).primaryColor,
                          )
                          : null,
                ),
                const SizedBox(width: 16),

                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.displayName ?? 'Sin nombre',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentUser)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Tú',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Status badge
                UserStatusBadge(status: user.status, compact: !isTablet),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Información adicional y controles
            if (isTablet)
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Creado',
                    value: _formatDate(user.creationTime),
                  ),
                  const SizedBox(width: 16),
                  _buildInfoChip(
                    context,
                    icon: Icons.login,
                    label: 'Último acceso',
                    value: _formatDate(user.lastSignInTime),
                  ),
                  const Spacer(),
                  UserRoleSelector(
                    currentRole: user.role,
                    onRoleChanged: onRoleChanged,
                    enabled: !isCurrentUser,
                  ),
                  const SizedBox(width: 16),
                  _buildActionsMenu(context),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoChip(
                          context,
                          icon: Icons.calendar_today,
                          label: 'Creado',
                          value: _formatDate(user.creationTime),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoChip(
                          context,
                          icon: Icons.login,
                          label: 'Último acceso',
                          value: _formatDate(user.lastSignInTime),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: UserRoleSelector(
                          currentRole: user.role,
                          onRoleChanged: onRoleChanged,
                          enabled: !isCurrentUser,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionsMenu(context),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String value) {
        switch (value) {
          case 'activate':
            onStatusChanged(UserStatus.active);
            break;
          case 'suspend':
            onStatusChanged(UserStatus.suspended);
            break;
          case 'deactivate':
            onStatusChanged(UserStatus.inactive);
            break;
          case 'delete':
            _showDeleteConfirmation(context);
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => [
            if (user.status != UserStatus.active)
              const PopupMenuItem<String>(
                value: 'activate',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 12),
                    Text('Activar'),
                  ],
                ),
              ),
            if (user.status != UserStatus.suspended)
              const PopupMenuItem<String>(
                value: 'suspend',
                child: Row(
                  children: [
                    Icon(Icons.pause_circle, color: Colors.orange, size: 20),
                    SizedBox(width: 12),
                    Text('Suspender'),
                  ],
                ),
              ),
            if (user.status != UserStatus.inactive)
              const PopupMenuItem<String>(
                value: 'deactivate',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.grey, size: 20),
                    SizedBox(width: 12),
                    Text('Desactivar'),
                  ],
                ),
              ),
            const PopupMenuDivider(),
            if (!isCurrentUser)
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Usuario'),
            content: Text(
              '¿Estás seguro de que deseas eliminar a ${user.displayName ?? user.email}?\n\n'
              'Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes}m';
      }
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

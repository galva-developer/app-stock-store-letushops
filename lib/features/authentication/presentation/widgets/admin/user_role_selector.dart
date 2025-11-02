import 'package:flutter/material.dart';
import '../../../domain/entities/auth_user.dart';

/// Selector de rol de usuario con dropdown
class UserRoleSelector extends StatelessWidget {
  final UserRole currentRole;
  final Function(UserRole) onRoleChanged;
  final bool enabled;

  const UserRoleSelector({
    super.key,
    required this.currentRole,
    required this.onRoleChanged,
    this.enabled = true,
  });

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.shade700;
      case UserRole.manager:
        return Colors.blue.shade700;
      case UserRole.employee:
        return Colors.grey.shade700;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.manager:
        return Icons.manage_accounts;
      case UserRole.employee:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(currentRole).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getRoleColor(currentRole).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserRole>(
          value: currentRole,
          isDense: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: _getRoleColor(currentRole),
            size: 20,
          ),
          onChanged:
              enabled
                  ? (UserRole? newRole) {
                    if (newRole != null) {
                      onRoleChanged(newRole);
                    }
                  }
                  : null,
          selectedItemBuilder: (BuildContext context) {
            return UserRole.values.map<Widget>((UserRole role) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 16,
                    color: _getRoleColor(role),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    role.displayName,
                    style: TextStyle(
                      color: _getRoleColor(role),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items:
              UserRole.values.map<DropdownMenuItem<UserRole>>((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Row(
                    children: [
                      Icon(
                        _getRoleIcon(role),
                        size: 20,
                        color: _getRoleColor(role),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            role.displayName,
                            style: TextStyle(
                              color: _getRoleColor(role),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _getRoleDescription(role),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Acceso completo al sistema';
      case UserRole.manager:
        return 'Gestión de inventario y reportes';
      case UserRole.employee:
        return 'Operaciones básicas';
    }
  }
}

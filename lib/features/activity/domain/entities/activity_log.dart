import 'package:equatable/equatable.dart';

/// Tipos de actividad en el sistema
enum ActivityType {
  productCreated,
  productUpdated,
  productDeleted,
  stockAdjusted,
  userCreated,
  userUpdated,
  userDeleted,
  login,
  logout;

  String get displayName {
    switch (this) {
      case ActivityType.productCreated:
        return 'Producto creado';
      case ActivityType.productUpdated:
        return 'Producto actualizado';
      case ActivityType.productDeleted:
        return 'Producto eliminado';
      case ActivityType.stockAdjusted:
        return 'Stock ajustado';
      case ActivityType.userCreated:
        return 'Usuario creado';
      case ActivityType.userUpdated:
        return 'Usuario actualizado';
      case ActivityType.userDeleted:
        return 'Usuario eliminado';
      case ActivityType.login:
        return 'Inicio de sesión';
      case ActivityType.logout:
        return 'Cierre de sesión';
    }
  }

  String get icon {
    switch (this) {
      case ActivityType.productCreated:
        return '➕';
      case ActivityType.productUpdated:
        return '✏️';
      case ActivityType.productDeleted:
        return '🗑️';
      case ActivityType.stockAdjusted:
        return '📦';
      case ActivityType.userCreated:
        return '👤';
      case ActivityType.userUpdated:
        return '✏️';
      case ActivityType.userDeleted:
        return '❌';
      case ActivityType.login:
        return '🔓';
      case ActivityType.logout:
        return '🔒';
    }
  }
}

/// Entidad de registro de actividad
class ActivityLog extends Equatable {
  final String id;
  final ActivityType type;
  final String userId;
  final String userName;
  final String userEmail;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.description,
    this.metadata,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    userId,
    userName,
    userEmail,
    description,
    metadata,
    timestamp,
  ];

  ActivityLog copyWith({
    String? id,
    ActivityType? type,
    String? userId,
    String? userName,
    String? userEmail,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/activity_log.dart';

/// Modelo de datos para ActivityLog en Firestore
class ActivityLogModel {
  final String id;
  final String type;
  final String userId;
  final String userName;
  final String userEmail;
  final String description;
  final Map<String, dynamic>? metadata;
  final Timestamp timestamp;

  ActivityLogModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.description,
    this.metadata,
    required this.timestamp,
  });

  /// Crear desde DocumentSnapshot de Firestore
  factory ActivityLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      id: doc.id,
      type: data['type'] as String,
      userId: data['userId'] as String,
      userName: data['userName'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      description: data['description'] as String,
      metadata: data['metadata'] as Map<String, dynamic>?,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'description': description,
      'metadata': metadata,
      'timestamp': timestamp,
    };
  }

  /// Crear desde entidad de dominio
  factory ActivityLogModel.fromEntity(ActivityLog activity) {
    return ActivityLogModel(
      id: activity.id,
      type: activity.type.name,
      userId: activity.userId,
      userName: activity.userName,
      userEmail: activity.userEmail,
      description: activity.description,
      metadata: activity.metadata,
      timestamp: Timestamp.fromDate(activity.timestamp),
    );
  }

  /// Convertir a entidad de dominio
  ActivityLog toEntity() {
    return ActivityLog(
      id: id,
      type: _parseActivityType(type),
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      description: description,
      metadata: metadata,
      timestamp: timestamp.toDate(),
    );
  }

  /// Parse string a ActivityType enum
  ActivityType _parseActivityType(String type) {
    try {
      return ActivityType.values.firstWhere((e) => e.name == type);
    } catch (e) {
      return ActivityType.productCreated; // Default fallback
    }
  }
}

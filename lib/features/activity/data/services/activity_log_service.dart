import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../authentication/domain/entities/auth_user.dart';
import '../../domain/entities/activity_log.dart';
import '../datasources/firebase_activity_datasource.dart';
import '../models/activity_log_model.dart';

/// Servicio para registrar actividades en el sistema
class ActivityLogService {
  final FirebaseActivityDataSource _dataSource;

  ActivityLogService({FirebaseActivityDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseActivityDataSource();

  /// Registrar creación de producto
  Future<void> logProductCreated({
    required AuthUser user,
    required String productId,
    required String productName,
  }) async {
    final activity = ActivityLogModel(
      id: '',
      type: ActivityType.productCreated.name,
      userId: user.uid,
      userName: user.displayName ?? 'Usuario',
      userEmail: user.email,
      description: 'Creó el producto "$productName"',
      metadata: {'productId': productId, 'productName': productName},
      timestamp: Timestamp.now(),
    );

    await _dataSource.logActivity(activity);
  }

  /// Registrar actualización de producto
  Future<void> logProductUpdated({
    required AuthUser user,
    required String productId,
    required String productName,
    Map<String, dynamic>? changes,
  }) async {
    final activity = ActivityLogModel(
      id: '',
      type: ActivityType.productUpdated.name,
      userId: user.uid,
      userName: user.displayName ?? 'Usuario',
      userEmail: user.email,
      description: 'Actualizó el producto "$productName"',
      metadata: {
        'productId': productId,
        'productName': productName,
        'changes': changes,
      },
      timestamp: Timestamp.now(),
    );

    await _dataSource.logActivity(activity);
  }

  /// Registrar eliminación de producto
  Future<void> logProductDeleted({
    required AuthUser user,
    required String productId,
    required String productName,
  }) async {
    final activity = ActivityLogModel(
      id: '',
      type: ActivityType.productDeleted.name,
      userId: user.uid,
      userName: user.displayName ?? 'Usuario',
      userEmail: user.email,
      description: 'Eliminó el producto "$productName"',
      metadata: {'productId': productId, 'productName': productName},
      timestamp: Timestamp.now(),
    );

    await _dataSource.logActivity(activity);
  }

  /// Registrar ajuste de stock
  Future<void> logStockAdjusted({
    required AuthUser user,
    required String productId,
    required String productName,
    required int oldStock,
    required int newStock,
    String? reason,
  }) async {
    final activity = ActivityLogModel(
      id: '',
      type: ActivityType.stockAdjusted.name,
      userId: user.uid,
      userName: user.displayName ?? 'Usuario',
      userEmail: user.email,
      description:
          'Ajustó stock de "$productName" de $oldStock a $newStock unidades',
      metadata: {
        'productId': productId,
        'productName': productName,
        'oldStock': oldStock,
        'newStock': newStock,
        'difference': newStock - oldStock,
        'reason': reason,
      },
      timestamp: Timestamp.now(),
    );

    await _dataSource.logActivity(activity);
  }

  /// Obtener actividades recientes
  Future<List<ActivityLog>> getRecentActivities({int limit = 10}) async {
    final models = await _dataSource.getRecentActivities(limit: limit);
    return models.map((model) => model.toEntity()).toList();
  }

  /// Stream de actividades en tiempo real
  Stream<List<ActivityLog>> watchRecentActivities({int limit = 10}) {
    return _dataSource
        .watchRecentActivities(limit: limit)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_log_model.dart';

/// DataSource de Firebase para registros de actividad
class FirebaseActivityDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'activity_logs';

  FirebaseActivityDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Registrar una nueva actividad
  Future<ActivityLogModel> logActivity(ActivityLogModel activity) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(activity.toFirestore());

      final doc = await docRef.get();
      return ActivityLogModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Error registrando actividad: $e');
    }
  }

  /// Obtener actividades recientes (limitadas)
  Future<List<ActivityLogModel>> getRecentActivities({int limit = 10}) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo actividades: $e');
    }
  }

  /// Obtener actividades de un usuario específico
  Future<List<ActivityLogModel>> getActivitiesByUser(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('userId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo actividades del usuario: $e');
    }
  }

  /// Obtener actividades por tipo
  Future<List<ActivityLogModel>> getActivitiesByType(
    String type, {
    int limit = 50,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('type', isEqualTo: type)
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo actividades por tipo: $e');
    }
  }

  /// Stream de actividades en tiempo real
  Stream<List<ActivityLogModel>> watchRecentActivities({int limit = 10}) {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ActivityLogModel.fromFirestore(doc))
                  .toList(),
        );
  }

  /// Limpiar actividades antiguas (opcional, para mantenimiento)
  Future<void> deleteOldActivities(DateTime olderThan) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('timestamp', isLessThan: Timestamp.fromDate(olderThan))
              .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Error eliminando actividades antiguas: $e');
    }
  }
}

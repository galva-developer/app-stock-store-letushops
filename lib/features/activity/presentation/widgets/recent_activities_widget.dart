import 'package:flutter/material.dart';
import '../../domain/entities/activity_log.dart';
import '../../data/services/activity_log_service.dart';

class RecentActivitiesWidget extends StatelessWidget {
  final ActivityLogService _activityService;

  RecentActivitiesWidget({super.key}) : _activityService = ActivityLogService();

  /// Formatea el timestamp como tiempo relativo (ej: "hace 5 minutos")
  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'hace ${difference.inSeconds} segundos';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} horas';
    } else if (difference.inDays < 7) {
      return 'hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'hace $years ${years == 1 ? 'año' : 'años'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actividad Reciente',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          StreamBuilder<List<ActivityLog>>(
            stream: _activityService.watchRecentActivities(limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error al cargar actividades: ${snapshot.error}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              }

              final activities = snapshot.data ?? [];

              if (activities.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No hay actividades recientes',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final activity = activities[index];

                  // Parsear el tipo de actividad
                  ActivityType activityType;
                  try {
                    activityType = ActivityType.values.firstWhere(
                      (e) => e.name == activity.type,
                      orElse: () => ActivityType.productCreated,
                    );
                  } catch (e) {
                    activityType = ActivityType.productCreated;
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        activityType.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      activity.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.description),
                        const SizedBox(height: 4),
                        Text(
                          _formatTimeAgo(activity.timestamp),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

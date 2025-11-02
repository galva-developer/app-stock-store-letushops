import 'package:flutter/material.dart';

/// Página de reportes y estadísticas
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // TODO: Select date range
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Export report
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de tipo de reporte
            _buildReportTypeSelector(context),
            const SizedBox(height: 24),

            // Contenido del reporte
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay datos disponibles',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Los reportes se generarán cuando tengas actividad',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _ReportTypeCard(
            title: 'Ventas',
            icon: Icons.shopping_cart,
            color: Colors.green,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _ReportTypeCard(
            title: 'Inventario',
            icon: Icons.inventory,
            color: Colors.blue,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _ReportTypeCard(
            title: 'Productos',
            icon: Icons.category,
            color: Colors.purple,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _ReportTypeCard(
            title: 'Movimientos',
            icon: Icons.swap_horiz,
            color: Colors.orange,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportTypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

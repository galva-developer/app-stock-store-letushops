import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Layout principal de la aplicación con navegación adaptativa
///
/// Implementa:
/// - Bottom Navigation Bar para móvil (< 600px)
/// - Navigation Rail para tablet (600-1200px)
/// - Navigation Drawer para desktop (> 1200px)
class MainLayout extends StatefulWidget {
  /// Widget hijo que se muestra en el contenido principal
  final Widget child;

  /// Índice de la navegación actual
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  /// Elementos de navegación
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      route: '/home',
    ),
    NavigationItem(
      label: 'Productos',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      route: '/products',
    ),
    NavigationItem(
      label: 'Cámara',
      icon: Icons.camera_alt_outlined,
      selectedIcon: Icons.camera_alt,
      route: '/camera',
    ),
    NavigationItem(
      label: 'Inventario',
      icon: Icons.store_outlined,
      selectedIcon: Icons.store,
      route: '/inventory',
    ),
    NavigationItem(
      label: 'Reportes',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      route: '/reports',
    ),
  ];

  void _onDestinationSelected(int index) {
    if (index != widget.currentIndex) {
      context.go(_navigationItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar el tipo de navegación según el ancho de pantalla
        final width = constraints.maxWidth;

        if (width < 600) {
          // Móvil: Bottom Navigation Bar
          return _buildMobileLayout();
        } else if (width < 1200) {
          // Tablet: Navigation Rail
          return _buildTabletLayout();
        } else {
          // Desktop: Navigation Drawer
          return _buildDesktopLayout();
        }
      },
    );
  }

  /// Layout para dispositivos móviles con Bottom Navigation Bar
  Widget _buildMobileLayout() {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations:
            _navigationItems
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
                )
                .toList(),
      ),
    );
  }

  /// Layout para tablets con Navigation Rail
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: widget.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.selected,
            destinations:
                _navigationItems
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  /// Layout para escritorio con Navigation Drawer persistente
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: widget.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            children: [
              // Header del drawer
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                child: Row(
                  children: [
                    // Logo de la aplicación
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo/logo-transparente.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock LetuShops',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Gestión de Inventarios',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ..._navigationItems.map(
                (item) => NavigationDrawerDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

/// Modelo para elementos de navegación
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}

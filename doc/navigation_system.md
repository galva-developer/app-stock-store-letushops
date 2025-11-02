# Sistema de Navegación Adaptativa

## Descripción General

El sistema de navegación de Stock LetuShops utiliza un diseño adaptativo que se ajusta automáticamente según el tamaño de pantalla del dispositivo, proporcionando la mejor experiencia de usuario en móviles, tablets y desktop.

## Componente Principal: MainLayout

**Ubicación:** `lib/features/home/presentation/pages/main_layout.dart`

### Tipos de Navegación Según Dispositivo

#### 📱 Móvil (< 600px)
- **Componente:** `NavigationBar` (Material 3)
- **Posición:** Parte inferior de la pantalla
- **Ventajas:**
  - Fácil acceso con el pulgar
  - Diseño familiar para usuarios móviles
  - Maximiza el espacio vertical

#### 📲 Tablet (600px - 1200px)
- **Componente:** `NavigationRail`
- **Posición:** Lateral izquierdo
- **Ventajas:**
  - Aprovecha el espacio horizontal disponible
  - Navegación siempre visible
  - Etiquetas opcionales para claridad

#### 💻 Desktop (> 1200px)
- **Componente:** `NavigationDrawer`
- **Posición:** Lateral izquierdo persistente
- **Ventajas:**
  - Navegación completa siempre visible
  - Incluye header con logo y título de la app
  - Mejor uso del espacio en pantallas grandes

## Estructura de Navegación

### Páginas Principales

| Ruta | Icono | Descripción | En Navegación Principal |
|------|-------|-------------|------------------------|
| `/home` | home | Dashboard principal | ✅ Sí |
| `/products` | inventory_2 | Gestión de productos | ✅ Sí |
| `/camera` | camera_alt | Escaneo de productos | ✅ Sí |
| `/inventory` | store | Control de inventario | ✅ Sí |
| `/reports` | analytics | Reportes y estadísticas | ✅ Sí |
| `/profile` | person | Perfil de usuario | ❌ No |
| `/settings` | settings | Configuración | ❌ No |

### Páginas Secundarias

Las páginas `/profile` y `/settings` no están en la navegación principal pero son accesibles desde:
- AppBar actions
- Drawer en desktop
- Links directos
- Deep links

## Integración con GoRouter

### StatefulShellRoute

Se utiliza `StatefulShellRoute.indexedStack` para:
- Mantener el estado de cada página al navegar
- Sincronizar el índice de navegación con la ruta actual
- Permitir navegación fluida entre secciones

**Ejemplo de configuración:**
```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainLayout(
      currentIndex: navigationShell.currentIndex,
      child: navigationShell,
    );
  },
  branches: [
    // Home branch
    StatefulShellBranch(
      routes: [
        GoRoute(path: home, name: 'home', ...),
      ],
    ),
    // ... más branches
  ],
)
```

### Navegación por Índice

Cada sección principal tiene un índice:
- 0: Home
- 1: Products
- 2: Camera
- 3: Inventory
- 4: Reports

Al hacer clic en un elemento de navegación, se usa `context.go()` para navegar a la ruta correspondiente.

## Características Implementadas

### ✅ Navegación Adaptativa
- Cambia automáticamente según el tamaño de pantalla
- Usa `LayoutBuilder` para determinar el tipo de navegación

### ✅ Preservación de Estado
- Cada página mantiene su estado al cambiar entre ellas
- Útil para formularios, scroll position, etc.

### ✅ Iconos Selected/Unselected
- Cada item tiene dos versiones del icono
- Mejora la experiencia visual al identificar la página actual

### ✅ Transiciones Suaves
- Animaciones de slide al navegar entre páginas
- Configuradas en `buildPageWithTransition()`

### ✅ Rutas Protegidas
- Integración con `RouteGuard`
- Redirección automática si no está autenticado

## Páginas Implementadas

### HomePage
**Ubicación:** `lib/features/home/presentation/pages/home_page.dart`

**Características:**
- Dashboard con bienvenida personalizada
- Estadísticas rápidas (productos, stock bajo)
- Accesos rápidos a funciones principales
- Feed de actividad reciente

### ProductsPage
**Ubicación:** `lib/features/products/presentation/pages/products_page.dart`

**Características:**
- Lista de productos (placeholder)
- Barra de búsqueda y filtros
- FAB para agregar productos
- Estado vacío con mensaje instructivo

### CameraPage
**Ubicación:** `lib/features/camera/presentation/pages/camera_page.dart`

**Características:**
- Placeholder para funcionalidad de cámara
- Preparado para integración con ML Kit
- Diseño con tema oscuro

### InventoryPage
**Ubicación:** `lib/features/inventory/presentation/pages/inventory_page.dart`

**Características:**
- Resumen de inventario (total, bajo stock, sin stock)
- Vista de categorías/productos
- Indicadores visuales de estado de stock

### ReportsPage
**Ubicación:** `lib/features/reports/presentation/pages/reports_page.dart`

**Características:**
- Selector de tipos de reporte
- Filtros por fecha
- Exportación de datos (preparado)
- Visualizaciones de datos (preparado)

## Personalización

### Agregar Nueva Página a la Navegación Principal

1. **Crear la página:**
```dart
class NewPage extends StatelessWidget {
  const NewPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Página')),
      body: Center(child: Text('Contenido')),
    );
  }
}
```

2. **Agregar ruta en `app_routes.dart`:**
```dart
static const String newPage = '/new-page';
```

3. **Agregar branch en StatefulShellRoute:**
```dart
StatefulShellBranch(
  routes: [
    GoRoute(
      path: newPage,
      name: 'new-page',
      pageBuilder: (context, state) => buildPageWithTransition(
        context: context,
        state: state,
        child: const NewPage(),
      ),
    ),
  ],
),
```

4. **Agregar item en `main_layout.dart`:**
```dart
NavigationItem(
  label: 'Nueva',
  icon: Icons.new_icon_outlined,
  selectedIcon: Icons.new_icon,
  route: '/new-page',
),
```

### Cambiar Breakpoints de Responsive

En `main_layout.dart`, modifica los valores en `LayoutBuilder`:

```dart
if (width < 600) {
  // Móvil
} else if (width < 1200) {
  // Tablet
} else {
  // Desktop
}
```

## Testing

### Probar Navegación Responsive

1. **En navegador web:**
   - `flutter run -d chrome`
   - Usa DevTools para cambiar tamaño de pantalla

2. **En emuladores:**
   - Android: Usa diferentes AVDs (phone, tablet, desktop)
   - iOS: Cambia entre iPhone, iPad

### Probar Preservación de Estado

1. Navega a una página
2. Scroll o ingresa datos en un formulario
3. Navega a otra página
4. Regresa a la primera
5. Verifica que el estado se mantiene

## Próximas Mejoras

- [ ] Agregar animaciones de transición entre tipos de navegación
- [ ] Implementar badges en items de navegación (ej: notificaciones)
- [ ] Agregar soporte para navegación por gestos
- [ ] Implementar navegación contextual (cambia según página)
- [ ] Agregar modo compacto para NavigationRail

## Referencias

- [Material 3 Navigation](https://m3.material.io/components/navigation-bar/overview)
- [GoRouter StatefulShellRoute](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html)
- [Responsive Design en Flutter](https://docs.flutter.dev/ui/layout/adaptive-responsive)

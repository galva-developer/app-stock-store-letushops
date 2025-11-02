import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Core imports
import '../../features/authentication/presentation/providers/auth_provider.dart';

// Route guard
import 'route_guard.dart';

// Authentication pages
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';

// Main layout
import '../../features/home/presentation/pages/main_layout.dart';

// Feature pages
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';

/// Main application routes configuration using GoRouter
class AppRoutes {
  // Route paths
  static const String splash = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String products = '/products';
  static const String inventory = '/inventory';
  static const String camera = '/camera';
  static const String reports = '/reports';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Main GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return RouteGuard.redirect(context, state);
    },
    routes: [
      // Root redirect to splash
      GoRoute(path: '/', redirect: (context, state) => splash),

      // Splash/Loading route
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication routes (public)
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder:
            (context, state) => buildPageWithTransition(
              context: context,
              state: state,
              child: const LoginPage(),
            ),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        pageBuilder:
            (context, state) => buildPageWithTransition(
              context: context,
              state: state,
              child: const ForgotPasswordPage(),
            ),
      ),

      // Protected routes with MainLayout
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
              GoRoute(
                path: home,
                name: 'home',
                pageBuilder:
                    (context, state) => buildPageWithTransition(
                      context: context,
                      state: state,
                      child: const HomePage(),
                    ),
              ),
            ],
          ),
          // Products branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: products,
                name: 'products',
                pageBuilder:
                    (context, state) => buildPageWithTransition(
                      context: context,
                      state: state,
                      child: const ProductsPage(),
                    ),
              ),
            ],
          ),
          // Camera branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: camera,
                name: 'camera',
                pageBuilder:
                    (context, state) => buildPageWithTransition(
                      context: context,
                      state: state,
                      child: const CameraPage(),
                    ),
              ),
            ],
          ),
          // Inventory branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: inventory,
                name: 'inventory',
                pageBuilder:
                    (context, state) => buildPageWithTransition(
                      context: context,
                      state: state,
                      child: const InventoryPage(),
                    ),
              ),
            ],
          ),
          // Reports branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: reports,
                name: 'reports',
                pageBuilder:
                    (context, state) => buildPageWithTransition(
                      context: context,
                      state: state,
                      child: const ReportsPage(),
                    ),
              ),
            ],
          ),
        ],
      ),

      // Profile route (outside main navigation)
      GoRoute(
        path: profile,
        name: 'profile',
        pageBuilder:
            (context, state) => buildPageWithTransition(
              context: context,
              state: state,
              child: const ProfilePage(),
            ),
      ),

      // Settings route (outside main navigation)
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder:
            (context, state) => buildPageWithTransition(
              context: context,
              state: state,
              child: const SettingsPage(),
            ),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );

  /// Builds pages with custom slide transition
  static Page<dynamic> buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

// Placeholder pages (to be implemented)
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAfterDelay();
  }

  void _checkAuthAfterDelay() async {
    // Esperar un tiempo mínimo para mostrar el splash
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Forzar una re-evaluación del estado de auth
      final authProvider = context.read<AuthProvider>();

      print('🔍 SplashPage - Auth Status:');
      print('   - isAuthenticated: ${authProvider.isAuthenticated}');
      print('   - isLoading: ${authProvider.isLoading}');
      print('   - hasError: ${authProvider.hasError}');
      print('   - currentUser: ${authProvider.currentUser?.email ?? 'null'}');

      // Simplemente forzar una navegación basada en el estado actual
      if (authProvider.isAuthenticated) {
        print('📍 Navegando a /home');
        context.go('/home');
      } else if (!authProvider.isLoading) {
        print('📍 Navegando a /login');
        context.go('/login');
      } else {
        print('⏳ Aún cargando, esperando...');
        // Si aún está cargando, esperar un poco más
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) _checkAuthAfterDelay();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la app
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/logo/logo-transparente.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Stock LetuShops',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gestión inteligente de inventarios',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Cargando...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(
              user?.email ?? 'Usuario',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'N/A'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await authProvider.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            subtitle: const Text('Personaliza la apariencia'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            subtitle: const Text('Gestiona tus alertas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            subtitle: const Text('Stock LetuShops v1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Ups! Algo salió mal'),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

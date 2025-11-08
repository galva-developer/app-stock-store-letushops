import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importaciones de configuración
import 'config/themes/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'firebase_options.dart';

// Importaciones de servicios
import 'core/services/session_persistence_service.dart';

// Importaciones de providers
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/authentication/presentation/providers/admin_users_provider.dart';
import 'features/products/presentation/providers/products_provider.dart';
import 'shared/providers/theme_provider.dart';

// Importaciones de dependencias de auth
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/data/datasources/firebase_auth_datasource.dart';

// Importaciones de dependencias de products
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/data/datasources/firebase_product_datasource.dart';
import 'features/products/domain/usecases/product_usecases.dart';

// Importaciones de use cases de admin
import 'features/authentication/domain/usecases/admin/list_all_users_usecase.dart';
import 'features/authentication/domain/usecases/admin/update_user_role_usecase.dart';
import 'features/authentication/domain/usecases/admin/update_user_status_usecase.dart';
import 'features/authentication/domain/usecases/admin/delete_user_usecase.dart';
import 'features/authentication/domain/usecases/admin/register_user_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar servicio de persistencia de sesión
  await SessionPersistenceService.instance.initialize();

  runApp(const StockLetuShopsApp());
}

class StockLetuShopsApp extends StatelessWidget {
  const StockLetuShopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear dependencias compartidas de autenticación
    final datasource = FirebaseAuthDataSource();
    final repository = AuthRepositoryImpl(datasource);

    // Crear dependencias de productos
    final productDataSource = FirebaseProductDataSource();
    final productRepository = ProductRepositoryImpl(productDataSource);

    return MultiProvider(
      providers: [
        // Theme Provider - Gestión del modo claro/oscuro
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),

        // Configuración del AuthProvider usando el factory
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            // Crear provider usando factory
            return AuthProviderFactory.create(authRepository: repository);
          },
        ),

        // Configuración del AdminUsersProvider
        ChangeNotifierProvider<AdminUsersProvider>(
          create: (context) {
            return AdminUsersProvider(
              listAllUsersUseCase: ListAllUsersUseCase(repository),
              updateUserRoleUseCase: UpdateUserRoleUseCase(repository),
              updateUserStatusUseCase: UpdateUserStatusUseCase(repository),
              deleteUserUseCase: DeleteUserUseCase(repository),
              registerUserUseCase: RegisterUserUseCase(repository),
            );
          },
        ),

        // Configuración del ProductsProvider
        ChangeNotifierProvider<ProductsProvider>(
          create: (context) {
            return ProductsProvider(
              createProductUseCase: CreateProductUseCase(productRepository),
              updateProductUseCase: UpdateProductUseCase(productRepository),
              deleteProductUseCase: DeleteProductUseCase(productRepository),
              getAllProductsUseCase: GetAllProductsUseCase(productRepository),
              searchProductsUseCase: SearchProductsUseCase(productRepository),
              getProductsByCategoryUseCase: GetProductsByCategoryUseCase(
                productRepository,
              ),
              getLowStockProductsUseCase: GetLowStockProductsUseCase(
                productRepository,
              ),
              getProductStatsUseCase: GetProductStatsUseCase(productRepository),
            );
          },
        ),
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, child) {
          return MaterialApp.router(
            title: 'Stock LetuShops',
            debugShowCheckedModeBanner: false,

            // Configuración de tema con modo oscuro
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Configuración de rutas con GoRouter
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}

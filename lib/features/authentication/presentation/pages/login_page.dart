import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

/// Pantalla de inicio de sesión
///
/// Permite a los usuarios autenticarse en la aplicación usando
/// email y contraseña. Incluye validaciones, manejo de errores
/// y navegación a otras pantallas de autenticación.
///
/// Características:
/// - Formulario responsive
/// - Validaciones en tiempo real
/// - Manejo de estados de carga
/// - Diseño moderno con paleta rojo-blanco-negro
/// - Integración con AuthProvider
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Mostrar mensajes de error/éxito
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleStateMessages(authProvider.state);
          });

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height - MediaQuery.of(context).padding.top - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header con logo
                      _buildHeader(),

                      const SizedBox(height: 40),

                      // Formulario de login
                      _buildLoginForm(authProvider),

                      const SizedBox(height: 24),

                      // Botón de login
                      _buildLoginButton(authProvider),

                      const SizedBox(height: 16),

                      // Enlace de "Olvidaste tu contraseña"
                      _buildForgotPasswordLink(),

                      const SizedBox(height: 32),

                      // Spacer para empujar contenido hacia arriba
                      const Spacer(),

                      // Footer
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el header con logo y título
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Logo de la aplicación
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD32F2F).withOpacity(0.2),
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

        const SizedBox(height: 24),

        // Título
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
          'Accede a tu cuenta de Stock LetuShops',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construye el formulario de login
  Widget _buildLoginForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de email
          _buildEmailField(authProvider.isLoading),

          const SizedBox(height: 20),

          // Campo de contraseña
          _buildPasswordField(authProvider.isLoading),

          const SizedBox(height: 16),

          // Checkbox "Recordarme"
          _buildRememberMeCheckbox(),
        ],
      ),
    );
  }

  /// Construye el campo de email
  Widget _buildEmailField(bool isLoading) {
    return TextFormField(
      controller: _emailController,
      enabled: !isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Ingresa tu email',
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFD32F2F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El email es requerido';
        }
        if (!RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(value.trim())) {
          return 'Ingresa un email válido';
        }
        return null;
      },
    );
  }

  /// Construye el campo de contraseña
  Widget _buildPasswordField(bool isLoading) {
    return TextFormField(
      controller: _passwordController,
      enabled: !isLoading,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Ingresa tu contraseña',
        prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFFD32F2F)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La contraseña es requerida';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el checkbox de "Recordarme"
  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          activeColor: const Color(0xFFD32F2F),
        ),
        const Text(
          'Recordarme',
          style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
        ),
      ],
    );
  }

  /// Construye el botón de login
  Widget _buildLoginButton(AuthProvider authProvider) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          elevation: 2,
          shadowColor: const Color(0xFFD32F2F).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            authProvider.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }

  /// Construye el enlace de "Olvidaste tu contraseña"
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.push('/forgot-password');
        },
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Color(0xFFD32F2F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Construye el footer
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        '© 2025 Stock LetuShops\nTodos los derechos reservados',
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Maneja el proceso de login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ocultar teclado
    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    print('🔑 Intentando login con: $email');

    final success = await authProvider.login(email, password);

    if (success && mounted) {
      // Obtener el usuario actual para verificar su rol
      final currentUser = authProvider.currentUser;

      print('👤 Usuario cargado: ${currentUser?.email}');
      print('🎭 Rol del usuario: ${currentUser?.role}');
      print('✅ Es admin: ${currentUser?.isAdmin}');

      // Redirigir según el rol del usuario
      if (currentUser != null && currentUser.isAdmin) {
        print('🔴 Redirigiendo a panel de administración...');
        // Si es administrador, redirigir al panel de administración
        context.go('/admin/users');
      } else {
        print('🏠 Redirigiendo a home...');
        // Navegación normal al home para managers y empleados
        context.go('/home');
      }
    } else {
      print('❌ Login fallido');
    }
  }

  /// Maneja los mensajes de estado
  void _handleStateMessages(AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.userMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // Limpiar el mensaje después de mostrarlo
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.read<AuthProvider>().clearMessages();
        }
      });
    } else if (state is AuthSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}

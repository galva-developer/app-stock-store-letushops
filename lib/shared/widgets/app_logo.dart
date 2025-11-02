import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar el logo de la aplicación
///
/// Puede mostrar el logo transparente o el logo blanco según el contexto
class AppLogo extends StatelessWidget {
  /// Tipo de logo a mostrar
  final LogoType type;

  /// Ancho del contenedor del logo
  final double width;

  /// Alto del contenedor del logo
  final double height;

  /// Si debe mostrar sombra
  final bool withShadow;

  /// Color de fondo del contenedor
  final Color? backgroundColor;

  /// Border radius del contenedor
  final double borderRadius;

  /// Padding interno del contenedor
  final double padding;

  const AppLogo({
    super.key,
    this.type = LogoType.transparent,
    this.width = 80,
    this.height = 80,
    this.withShadow = true,
    this.backgroundColor,
    this.borderRadius = 12,
    this.padding = 12,
  });

  /// Constructor para el logo circular
  const AppLogo.circular({
    super.key,
    this.type = LogoType.transparent,
    this.width = 80,
    this.height = 80,
    this.withShadow = true,
    this.backgroundColor,
    this.padding = 16,
  }) : borderRadius = 9999; // Valor grande para hacer círculo

  /// Constructor para logo pequeño sin decoración
  const AppLogo.simple({
    super.key,
    this.type = LogoType.transparent,
    this.width = 40,
    this.height = 40,
    this.padding = 0,
  }) : withShadow = false,
       backgroundColor = null,
       borderRadius = 0;

  @override
  Widget build(BuildContext context) {
    final logoPath =
        type == LogoType.transparent
            ? 'assets/images/logo/logo-transparente.png'
            : 'assets/images/logo/logo-blanco.png';

    Widget logoImage = Image.asset(
      logoPath,
      width: width - (padding * 2),
      height: height - (padding * 2),
      fit: BoxFit.contain,
    );

    // Si no tiene decoración, retornar solo la imagen
    if (!withShadow && backgroundColor == null && borderRadius == 0) {
      return SizedBox(width: width, height: height, child: logoImage);
    }

    // Construir con decoración
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            withShadow
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: logoImage,
    );
  }
}

/// Tipo de logo a mostrar
enum LogoType {
  /// Logo con fondo transparente
  transparent,

  /// Logo con elementos blancos (para fondos oscuros)
  white,
}

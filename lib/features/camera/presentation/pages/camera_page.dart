import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';

/// Página de cámara para escanear productos
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara'),
        backgroundColor: ColorConstants.primaryColor, // Siempre rojo
        foregroundColor: ColorConstants.textOnPrimaryColor, // Siempre blanco
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Cámara no disponible',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'La función de cámara se implementará pronto',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Open camera
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Abrir Cámara'),
            ),
          ],
        ),
      ),
    );
  }
}

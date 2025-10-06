import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tarea_map/constants/config.dart';

class ConfigInfoScreen extends StatelessWidget {
  const ConfigInfoScreen({super.key});

  // Check if environment variable exists and has a value
  bool _envExists(String key) {
    return dotenv.env.containsKey(key) && dotenv.env[key]!.isNotEmpty;
  }

  // Get environment variable value or return 'Not Set'
  String _envValue(String key) {
    return dotenv.env[key] ?? 'Not Set';
  }

  // Build status indicator
  Widget _buildStatusIndicator(bool exists) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: exists ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: exists ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            exists ? Icons.check_circle : Icons.error,
            size: 16,
            color: exists ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            exists ? 'Loaded' : 'Missing',
            style: TextStyle(
              color: exists ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Build environment variable card
  Widget _buildEnvCard({
    required BuildContext context,
    required String title,
    required String envKey,
    required IconData icon,
    bool obscureValue = false,
    bool copyClipboard = true,
  }) {
    final exists = _envExists(envKey);
    final value = _envValue(envKey);
    final displayValue = obscureValue && exists
        ? '${value.substring(0, 8)}...' // Show only first 8 chars for API keys
        : value;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusIndicator(exists),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: exists ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                  if (exists && copyClipboard)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$title copied to clipboard!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check overall configuration status
    final allEnvsLoaded = _envExists('DEFAULT_LAT') &&
        _envExists('DEFAULT_LNG') &&
        _envExists('GOOGLE_MAPS_API_KEY');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración e Información'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: allEnvsLoaded
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.orange.shade400, Colors.orange.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    allEnvsLoaded ? Icons.check_circle : Icons.warning,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    allEnvsLoaded
                        ? 'Todas las configuraciones cargadas'
                        : 'Configuración faltante',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    allEnvsLoaded
                        ? 'Tu aplicación está lista para usarse!'
                        : 'Por favor, verifica tu archivo .env',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Variables de Entorno',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configuración cargada desde el archivo .env',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // Environment Variable Cards
            _buildEnvCard(
              context: context,
              title: 'Latitud por Defecto',
              envKey: 'DEFAULT_LAT',
              icon: Icons.location_on,
            ),

            _buildEnvCard(
              context: context,
              title: 'Longitud por Defecto',
              envKey: 'DEFAULT_LNG',
              icon: Icons.location_on,
            ),

            _buildEnvCard(
              context: context,
              title: 'Google Maps API Key',
              envKey: 'GOOGLE_MAPS_API_KEY',
              icon: Icons.key,
              obscureValue: true,
              copyClipboard: false,
            ),

            const SizedBox(height: 24),

            // Current Configuration Values
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Text(
                          'Configuración Actual de la App',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Latitud por Defecto',
                      '${AppConfig.defaultLocation.latitude.toStringAsFixed(6)}, '
                          '${AppConfig.defaultLocation.longitude.toStringAsFixed(6)}',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'API Key:',
                      AppConfig.googleMapsApiKey.isNotEmpty ? ' Yes' : ' No',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Text(
                          'Cómo Configurar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Crea un archivo .env en la raíz del proyecto\n'
                      '2. Agrega las siguientes variables:\n'
                      '   DEFAULT_LAT=tu_latitud\n'
                      '   DEFAULT_LNG=tu_longitud\n'
                      '   GOOGLE_MAPS_API_KEY=tu_api_key\n'
                      '3. Reinicia la aplicación',
                      style: TextStyle(fontSize: 14, height: 1.5),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}

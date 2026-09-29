import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String _deviceInfoText = 'Cargando información del dispositivo...';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    if (!Platform.isIOS) {
      setState(() {
        _deviceInfoText = 'Información no disponible (no es iOS)';
      });
      return;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      
      final machine = iosInfo.utsname.machine;
      final systemVersion = iosInfo.systemVersion;
      
      // Mapeo básico para dispositivos comunes (ejemplo)
      String modelo = machine;
      String procesador = 'Desconocido';
      String arquitectura = 'ARM64';
      String config = 'Desconocido';
      String cacheL1 = 'Desconocido';
      String cacheL2 = 'Desconocido';
      String lineSize = '128 bytes';
      String ram = 'Desconocido';
      
      if (machine.startsWith('iPhone15,4') || machine.startsWith('iPhone15,5')) {
        modelo = 'iPhone 15 ($machine)';
        procesador = 'Apple A16 Bionic (6 núcleos)';
        arquitectura = 'ARM64 (v8.6-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '16 MB';
        ram = '6 GB LPDDR5';
      } else if (machine.startsWith('iPhone16,1') || machine.startsWith('iPhone16,2')) {
        modelo = 'iPhone 15 Pro ($machine)';
        procesador = 'Apple A17 Pro (6 núcleos)';
        arquitectura = 'ARM64 (v8.6-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '16 MB';
        ram = '8 GB LPDDR5';
      } else if (machine.startsWith('iPhone14,7') || machine.startsWith('iPhone14,8')) {
        modelo = 'iPhone 14 ($machine)';
        procesador = 'Apple A15 Bionic (6 núcleos)';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '12 MB';
        ram = '6 GB LPDDR4X';
      } else if (machine.startsWith('iPhone14,2') || machine.startsWith('iPhone14,3')) {
        modelo = 'iPhone 13 Pro ($machine)';
        procesador = 'Apple A15 Bionic (6 núcleos)';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '12 MB';
        ram = '6 GB LPDDR4X';
      } else if (machine.startsWith('iPhone13,2') || machine.startsWith('iPhone13,3') || machine.startsWith('iPhone13,4') || machine.startsWith('iPhone13,1')) {
        modelo = 'iPhone 12 ($machine)';
        procesador = 'Apple A14 Bionic (6 núcleos)';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '8 MB';
        ram = '4/6 GB LPDDR4X';
      } else if (machine == 'arm64' || machine == 'x86_64') {
        modelo = 'Simulador iOS ($machine)';
        procesador = 'Mac CPU';
        config = 'Virtual';
        cacheL1 = 'N/A';
        cacheL2 = 'N/A';
        ram = 'N/A';
      } else {
        modelo = 'Apple Device ($machine)';
        procesador = 'Apple Silicon';
      }

      // Helper for padding
      String pad(String text, int width) => text.padRight(width);

      final table = 
        '┌─────────────────────────────────────────────────────┐\n'
        '│ 📱 DISPOSITIVO DETECTADO                            │\n'
        '├─────────────────────────────────────────────────────┤\n'
        '│ • Modelo:         ${pad(modelo, 34)}│\n'
        '│ • Procesador:     ${pad(procesador, 34)}│\n'
        '│ • Arquitectura:   ${pad(arquitectura, 34)}│\n'
        '│ • Configuración:  ${pad(config, 34)}│\n'
        '│ • Caché L1 Datos: ${pad(cacheL1, 34)}│\n'
        '│ • Caché L2:       ${pad(cacheL2, 34)}│\n'
        '│ • Tamaño Línea:   ${pad(lineSize, 34)}│\n'
        '│ • Memoria RAM:    ${pad(ram, 34)}│\n'
        '│ • Sistema:        ${pad('iOS $systemVersion', 34)}│\n'
        '└─────────────────────────────────────────────────────';

      setState(() {
        _deviceInfoText = table;
      });
    } catch (e) {
      setState(() {
        _deviceInfoText = 'Error al cargar info: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Qué es RendiM?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'App de benchmarking de multiplicación de matrices diseñada para medir el rendimiento del procesador en iOS, comparando distintas variantes algorítmicas.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildListItem('Variantes de índices (RF20)'),
              _buildListItem('Niveles de optimización (RF21)'),
              _buildListItem('Técnicas de optimización'),
              _buildListItem('Glosario'),
              _buildListItem('Info del dispositivo (RF22)'),
              _buildListItem('Contacto / Autor'),
              
              const SizedBox(height: 48),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _deviceInfoText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier',
                    fontSize: 12,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Navegar a la sección de información correspondiente
      },
    );
  }
}

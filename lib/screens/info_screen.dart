import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Map<String, dynamic>? _deviceInfoMap;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    if (!Platform.isIOS) {
      setState(() {
        _errorMessage = 'Información no disponible (no es iOS)';
      });
      return;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      
      final machine = iosInfo.utsname.machine;
      final systemVersion = iosInfo.systemVersion;
      
      String modelo = machine;
      String procesador = 'Desconocido';
      String arquitectura = 'ARM64';
      String config = 'Desconocido';
      String cacheL1 = 'Desconocido';
      String cacheL2 = 'Desconocido';
      String lineSize = '128 bytes';
      String ram = 'Desconocido';
      String chipName = 'AXX';
      
      if (machine.startsWith('iPhone15,4') || machine.startsWith('iPhone15,5')) {
        modelo = 'iPhone 15 ($machine)';
        procesador = 'Apple A16 Bionic';
        chipName = 'A16';
        arquitectura = 'ARM64 (v8.6-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '16 MB';
        ram = '6 GB LPDDR5';
      } else if (machine.startsWith('iPhone16,1') || machine.startsWith('iPhone16,2')) {
        modelo = 'iPhone 15 Pro ($machine)';
        procesador = 'Apple A17 Pro';
        chipName = 'A17';
        arquitectura = 'ARM64 (v8.6-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '16 MB';
        ram = '8 GB LPDDR5';
      } else if (machine.startsWith('iPhone14,7') || machine.startsWith('iPhone14,8')) {
        modelo = 'iPhone 14 ($machine)';
        procesador = 'Apple A15 Bionic';
        chipName = 'A15';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '12 MB';
        ram = '6 GB LPDDR4X';
      } else if (machine.startsWith('iPhone14,2') || machine.startsWith('iPhone14,3')) {
        modelo = 'iPhone 13 Pro ($machine)';
        procesador = 'Apple A15 Bionic';
        chipName = 'A15';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '12 MB';
        ram = '6 GB LPDDR4X';
      } else if (machine.startsWith('iPhone13,2') || machine.startsWith('iPhone13,3') || machine.startsWith('iPhone13,4') || machine.startsWith('iPhone13,1')) {
        modelo = 'iPhone 12 ($machine)';
        procesador = 'Apple A14 Bionic';
        chipName = 'A14';
        arquitectura = 'ARM64 (v8.5-A)';
        config = '2P + 4E Cores';
        cacheL1 = '128 KB';
        cacheL2 = '8 MB';
        ram = '4/6 GB LPDDR4X';
      } else if (machine == 'arm64' || machine == 'x86_64') {
        modelo = 'Simulador iOS ($machine)';
        procesador = 'Mac CPU';
        chipName = 'M1/2';
        config = 'Virtual';
        cacheL1 = 'N/A';
        cacheL2 = 'N/A';
        ram = 'N/A';
      } else {
        modelo = 'Apple Device ($machine)';
        procesador = 'Apple Silicon';
        chipName = 'APP';
      }

      setState(() {
        _deviceInfoMap = {
          'modelo': modelo,
          'procesador': procesador,
          'chipName': chipName,
          'arquitectura': arquitectura,
          'config': config,
          'cacheL1': cacheL1,
          'cacheL2': cacheL2,
          'lineSize': lineSize,
          'ram': ram,
          'systemVersion': 'iOS $systemVersion',
        };
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar info: $e';
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
              
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red))
              else if (_deviceInfoMap == null)
                const CircularProgressIndicator()
              else
                _buildModernDeviceCard(_deviceInfoMap!),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernDeviceCard(Map<String, dynamic> info) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF11141E), // Dark background matching the image
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_iphone, color: Color(0xFF00D1FF), size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'DISPOSITIVO\nDETECTADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    height: 1.1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00D1FF).withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00D1FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVO',
                      style: TextStyle(
                        color: Color(0xFF00D1FF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Processor Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00D1FF), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  info['chipName'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info['procesador'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '6 núcleos (2 Performance + 4 Efficiency)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'ARMv8.\n6-A',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF00D1FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          
          // Data Rows
          _buildInfoRow('Modelo del\ndispositivo', info['modelo']),
          _buildInfoRow('Arquitectura\nCPU', info['arquitectura']),
          _buildInfoRow('Configuración\nnúcleos', info['config']),
          _buildInfoRow('Caché L1 Datos (P-\nCore)', info['cacheL1'], highlightValue: true),
          _buildInfoRow('Caché L2\nCompartida', info['cacheL2'], highlightValue: true),
          _buildInfoRow('Tamaño línea de\ncaché', info['lineSize']),
          _buildInfoRow('Memoria RAM\nfísica', info['ram']),
          _buildInfoRow('Versión del\nsistema', info['systemVersion']),
          
          const SizedBox(height: 16),
          
          // Footer Note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.circle, color: Color(0xFF00D1FF), size: 6),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Perfil de hardware listo para pruebas de\nmemoria caché',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool highlightValue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: highlightValue ? const Color(0xFF00D1FF) : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


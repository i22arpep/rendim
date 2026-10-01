import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/test_config.dart';
import '../widgets/pill_selector.dart';
import 'execution_screen.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final config = appState.config;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Prueba', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('TAMAÑO DE MATRIZ', isDark),
              PillSelector<int>(
                options: const [128, 256, 512, 1024, 2048],
                selectedValue: config.matrixSize,
                labelBuilder: (val) => val.toString(),
                onChanged: (val) => appState.updateConfig(config.copyWith(matrixSize: val)),
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('VARIANTE DE ÍNDICES', isDark),
              _buildDropdown<IndexVariant>(
                value: config.indexVariant,
                items: IndexVariant.values,
                labelBuilder: (val) => val.name.toUpperCase().split('').join(', '),
                onChanged: (val) => appState.updateConfig(config.copyWith(indexVariant: val!)),
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('TÉCNICA DE OPTIMIZACIÓN', isDark),
              _buildDropdown<OptimizationTechnique>(
                value: config.technique,
                items: const [OptimizationTechnique.localidadEspacial], // Solo permitir localidad espacial
                labelBuilder: (val) {
                  switch(val) {
                    case OptimizationTechnique.localidadEspacial: return 'Localidad Espacial';
                    default: return 'Desconocido';
                  }
                },
                onChanged: (val) => appState.updateConfig(config.copyWith(technique: val!)),
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('NIVEL DE OPTIMIZACIÓN', isDark),
              _buildDropdown<OptimizationLevel>(
                value: config.level,
                items: OptimizationLevel.values,
                labelBuilder: (val) {
                  switch(val) {
                    case OptimizationLevel.none: return 'Sin Optimizar (O0)';
                    case OptimizationLevel.o1: return 'Básico (O1)';
                    case OptimizationLevel.o2: return 'Optimizado (O2)';
                    case OptimizationLevel.o3: return 'Agresivo (O3)';
                  }
                },
                onChanged: (val) => appState.updateConfig(config.copyWith(level: val!)),
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('TIPO DE DATO', isDark),
              PillSelector<DataType>(
                options: DataType.values,
                selectedValue: config.dataType,
                labelBuilder: (val) => val.name.toUpperCase(),
                onChanged: (val) => appState.updateConfig(config.copyWith(dataType: val)),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('REPETICIONES', isDark),
              PillSelector<int>(
                options: const [1, 5, 10, 20],
                selectedValue: config.repetitions,
                labelBuilder: (val) => val.toString(),
                onChanged: (val) => appState.updateConfig(config.copyWith(repetitions: val)),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    appState.startTest();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExecutionScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, color: Color(0xFF1E1E1E) /* Muted to look like design */), // The design shows a dark play icon inside the dark button, or maybe it's just very dark gray. We'll use grey.
                  label: const Text(
                    'EJECUTAR PRUEBA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.white : Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : Colors.black),
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          isExpanded: true,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

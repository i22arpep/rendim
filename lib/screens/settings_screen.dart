import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/pill_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('TEMA VISUAL', isDark),
              PillSelector<bool>(
                options: const [false, true],
                selectedValue: appState.isDarkMode,
                labelBuilder: (val) => val ? 'Oscuro' : 'Claro',
                onChanged: (val) => appState.toggleTheme(val),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('IDIOMA', isDark),
              PillSelector<bool>(
                options: const [false, true],
                selectedValue: appState.isEnglish,
                labelBuilder: (val) => val ? 'English' : 'Español',
                onChanged: (val) => appState.toggleLanguage(val),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle('REPETICIONES POR DEFECTO', isDark),
              PillSelector<int>(
                options: const [1, 5, 10, 20],
                selectedValue: appState.defaultRepetitions,
                labelBuilder: (val) => val.toString(),
                onChanged: (val) => appState.setDefaultRepetitions(val),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  _buildSectionTitle('VER TUTORIAL', isDark),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // Acción de relanzar tutorial
                    },
                    child: Text(
                      'Relanzar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              
              Center(
                child: Column(
                  children: [
                    Text('Versión', style: TextStyle(color: Colors.grey[400])),
                    const Text('v1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Autor', style: TextStyle(color: Colors.grey[400])),
                    const Text('Pablo Mª Arroyo Pérez', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
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
}

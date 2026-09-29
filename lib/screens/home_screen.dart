import 'package:flutter/material.dart';
import 'config_screen.dart';
import 'info_screen.dart';
import 'settings_screen.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'RendiM',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                Text(
                  'Benchmark para IOS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 60),
                PrimaryButton(
                  text: 'Configurar Prueba',
                  icon: Icons.arrow_circle_right_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConfigScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Información',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InfoScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Ajustes',
                  icon: Icons.settings_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

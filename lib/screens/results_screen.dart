import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/primary_button.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final result = appState.lastResult;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (result == null) {
      return const Scaffold(body: Center(child: Text('No hay resultados.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjetas de Métricas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricCard(context, 'Media', result.media, isDark),
                  _buildMetricCard(context, 'Mediana', result.mediana, isDark),
                  _buildMetricCard(context, 'Desviación', result.desviacion, isDark),
                ],
              ),
              const SizedBox(height: 24),
              
              Text(
                'Tiempo total: 00: 00 .${result.tiempoTotal.toInt()} s',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              Text(
                'REPETICIONES',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),

              // Lista de repeticiones
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.grey)),
                        Text('Tiempo', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.grey)),
                      ],
                    ),
                    const Divider(height: 24),
                    ...List.generate(result.repeticiones.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${result.repeticiones[index].toStringAsFixed(1)} ms',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Figma Mono'),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              PrimaryButton(
                text: 'NUEVA PRUEBA',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'VOLVER AL INICIO',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, double value, bool isDark) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48 - 24) / 3, // 3 columns with spacing
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white : Colors.black, width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const Text('ms', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }
}

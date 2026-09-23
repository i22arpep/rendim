import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/test_result.dart';
import 'results_screen.dart';

class ExecutionScreen extends StatefulWidget {
  const ExecutionScreen({super.key});

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  @override
  void initState() {
    super.initState();
    // Iniciar la lógica real de ejecución en segundo plano aquí.
    // Por ahora, simularemos la ejecución para probar la UI.
    _simulateExecution();
  }

  Future<void> _simulateExecution() async {
    final appState = context.read<AppState>();
    final reps = appState.config.repetitions;
    final times = <double>[];

    for (int i = 1; i <= reps; i++) {
      if (appState.cancelRequested) break;
      
      // Simulamos tiempo de cómputo
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final progress = i / reps;
      times.add(12.0 + (i % 2) * 0.5); // Tiempo simulado en ms
      
      appState.updateProgress(progress, i, "00:00.${(i * 50).toString().padLeft(2, '0')}");
    }

    if (!appState.cancelRequested && mounted) {
      // Calcular métricas
      final media = times.reduce((a, b) => a + b) / times.length;
      final timeTotal = times.reduce((a, b) => a + b); // simulado
      
      final result = TestResult(
        media: media,
        mediana: 12.1, // simulado
        desviacion: 0.23, // simulado
        tiempoTotal: timeTotal,
        repeticiones: times,
      );
      
      appState.finishTest(result);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejecutando Prueba ...', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Ocultar botón de atrás
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Porcentaje grande
              Text(
                '${(appState.progress * 100).toInt()} %',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              
              // Barra de progreso gruesa tipo pila
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.white : Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: (appState.progress * 100).toInt(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(5),
                            bottomLeft: const Radius.circular(5),
                            topRight: appState.progress == 1.0 ? const Radius.circular(5) : Radius.zero,
                            bottomRight: appState.progress == 1.0 ? const Radius.circular(5) : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100 - (appState.progress * 100).toInt(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Repetición ${appState.currentRepetition} de ${appState.config.repetitions}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Tiempo: ${appState.currentExecutionTime}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              
              const Spacer(),
              
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
                    appState.cancelTest();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                  label: const Text(
                    'CANCELAR PRUEBA',
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
}

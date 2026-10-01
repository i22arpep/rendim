import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/test_config.dart';
import '../models/test_result.dart';
import '../services/engine_service.dart';
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
    _runExecution();
  }

  Future<void> _runExecution() async {
    final appState = context.read<AppState>();
    final reps = appState.config.repetitions;
    final n = appState.config.matrixSize;
    final variant = appState.config.indexVariant;
    final times = <double>[];
    
    final engine = EngineService();

    // Asignar memoria para las matrices
    final totalElements = n * n;
    final pointerA = calloc<Float>(totalElements);
    final pointerB = calloc<Float>(totalElements);
    final pointerC = calloc<Float>(totalElements);

    // Inicializar matrices A y B
    for (int i = 0; i < totalElements; i++) {
      pointerA[i] = 1.0;
      pointerB[i] = 2.0;
      pointerC[i] = 0.0;
    }

    final stopwatch = Stopwatch();

    for (int i = 1; i <= reps; i++) {
      if (appState.cancelRequested) break;
      
      // Permitir que la interfaz se actualice antes de bloquear el hilo
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) break;

      stopwatch.reset();
      stopwatch.start();

      // Obtener la función correcta del motor y ejecutarla
      final func = engine.getFunction(variant.toString(), appState.config.level.toString());
      func(pointerA, pointerB, pointerC, n);

      stopwatch.stop();
      
      final elapsedMs = stopwatch.elapsedMicroseconds / 1000.0;
      times.add(elapsedMs);
      
      final progress = i / reps;
      
      // Formatear tiempo
      final totalSeconds = (elapsedMs / 1000.0).floor();
      final ms = (elapsedMs % 1000.0).floor();
      final timeStr = "00:${totalSeconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}";
      
      appState.updateProgress(progress, i, timeStr);
    }
    
    // Liberar memoria (muy importante para evitar memory leaks)
    calloc.free(pointerA);
    calloc.free(pointerB);
    calloc.free(pointerC);

    if (!appState.cancelRequested && mounted) {
      // Calcular métricas
      final sortedTimes = List<double>.from(times)..sort();
      final media = times.reduce((a, b) => a + b) / times.length;
      final mediana = sortedTimes[sortedTimes.length ~/ 2];
      
      double sumSquares = 0.0;
      for (final t in times) {
        sumSquares += (t - media) * (t - media);
      }
      
      final desviacion = times.length > 1 ? math.sqrt(sumSquares / (times.length - 1)) : 0.0;
      
      final timeTotal = times.reduce((a, b) => a + b);
      
      final result = TestResult(
        media: media,
        mediana: mediana,
        desviacion: desviacion,
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

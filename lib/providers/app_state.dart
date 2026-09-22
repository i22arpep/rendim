import 'package:flutter/material.dart';
import '../models/test_config.dart';
import '../models/test_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  // Configuración por defecto
  TestConfig config = TestConfig(
    matrixSize: 512,
    indexVariant: IndexVariant.ijk,
    technique: OptimizationTechnique.localidadEspacial,
    level: OptimizationLevel.o2,
    dataType: DataType.decimal,
    repetitions: 10,
  );

  TestResult? lastResult;
  bool isRunning = false;
  double progress = 0.0;
  int currentRepetition = 0;
  String currentExecutionTime = "00:00.00";
  bool cancelRequested = false;

  // Ajustes de usuario
  bool isDarkMode = false;
  bool isEnglish = false;
  int defaultRepetitions = 10;

  AppState() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    isEnglish = prefs.getBool('isEnglish') ?? false;
    defaultRepetitions = prefs.getInt('defaultRepetitions') ?? 10;
    config = config.copyWith(repetitions: defaultRepetitions);
    notifyListeners();
  }

  void updateConfig(TestConfig newConfig) {
    config = newConfig;
    notifyListeners();
  }

  void toggleTheme(bool value) async {
    isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void toggleLanguage(bool english) async {
    isEnglish = english;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', english);
  }

  void setDefaultRepetitions(int reps) async {
    defaultRepetitions = reps;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('defaultRepetitions', reps);
  }

  void startTest() {
    isRunning = true;
    cancelRequested = false;
    progress = 0.0;
    currentRepetition = 0;
    lastResult = null;
    notifyListeners();
  }

  void updateProgress(double prog, int rep, String timeStr) {
    progress = prog;
    currentRepetition = rep;
    currentExecutionTime = timeStr;
    notifyListeners();
  }

  void finishTest(TestResult result) {
    lastResult = result;
    isRunning = false;
    notifyListeners();
  }

  void cancelTest() {
    cancelRequested = true;
    isRunning = false;
    notifyListeners();
  }
}

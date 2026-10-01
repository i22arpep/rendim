import 'dart:ffi';
import 'dart:io';

// Typedefs for FFI
typedef MatrixMultiplicationC = Void Function(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, Int32 n);
typedef MatrixMultiplicationDart = void Function(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, int n);

class EngineService {
  late DynamicLibrary _lib;
  final Map<String, MatrixMultiplicationDart> _cache = {};

  EngineService() {
    if (Platform.isIOS || Platform.isMacOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError("Plataforma no soportada para FFI en este proyecto");
    }
  }

  MatrixMultiplicationDart getFunction(String variant, String level) {
    String suffix = "";
    if (level == "none" || level == "OptimizationLevel.none") suffix = "_o0";
    else if (level == "o1" || level == "OptimizationLevel.o1") suffix = "_o1";
    else if (level == "o2" || level == "OptimizationLevel.o2") suffix = "_o2";
    else if (level == "o3" || level == "OptimizationLevel.o3") suffix = "_o3";
    
    // variant normally comes as "IndexVariant.ijk", extract "ijk"
    String cleanVariant = variant;
    if (variant.contains(".")) {
      cleanVariant = variant.split(".").last;
    }

    final functionName = "matrix_multiplication_${cleanVariant}${suffix}";
    
    if (!_cache.containsKey(functionName)) {
      _cache[functionName] = _lib.lookup<NativeFunction<MatrixMultiplicationC>>(functionName).asFunction<MatrixMultiplicationDart>();
    }
    
    return _cache[functionName]!;
  }
}

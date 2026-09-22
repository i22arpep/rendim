import 'dart:ffi';
import 'dart:io';

// Typedefs for FFI
typedef MatrixMultiplicationC = Void Function(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, Int32 n);
typedef MatrixMultiplicationDart = void Function(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, int n);

class EngineService {
  late DynamicLibrary _lib;
  late MatrixMultiplicationDart _multIjk;
  late MatrixMultiplicationDart _multIkj;

  EngineService() {
    if (Platform.isIOS || Platform.isMacOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError("Plataforma no soportada para FFI en este proyecto");
    }

    _multIjk = _lib
        .lookup<NativeFunction<MatrixMultiplicationC>>('matrix_multiplication_ijk')
        .asFunction();
        
    _multIkj = _lib
        .lookup<NativeFunction<MatrixMultiplicationC>>('matrix_multiplication_ikj')
        .asFunction();
  }

  void multiplyIjk(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, int n) {
    _multIjk(a, b, c, n);
  }

  void multiplyIkj(Pointer<Float> a, Pointer<Float> b, Pointer<Float> c, int n) {
    _multIkj(a, b, c, n);
  }
}

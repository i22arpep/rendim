enum IndexVariant {
  ijk,
  ikj,
  jik,
  jki,
  kij,
  kji,
}

enum OptimizationTechnique {
  localidadEspacial,
  localidadTemporal,
  permutacion,
  padding,
  tiling
}

enum OptimizationLevel {
  none,
  o1,
  o2,
  o3
}

enum DataType {
  entero,
  decimal
}

class TestConfig {
  final int matrixSize;
  final IndexVariant indexVariant;
  final OptimizationTechnique technique;
  final OptimizationLevel level;
  final DataType dataType;
  final int repetitions;

  TestConfig({
    required this.matrixSize,
    required this.indexVariant,
    required this.technique,
    required this.level,
    required this.dataType,
    required this.repetitions,
  });

  TestConfig copyWith({
    int? matrixSize,
    IndexVariant? indexVariant,
    OptimizationTechnique? technique,
    OptimizationLevel? level,
    DataType? dataType,
    int? repetitions,
  }) {
    return TestConfig(
      matrixSize: matrixSize ?? this.matrixSize,
      indexVariant: indexVariant ?? this.indexVariant,
      technique: technique ?? this.technique,
      level: level ?? this.level,
      dataType: dataType ?? this.dataType,
      repetitions: repetitions ?? this.repetitions,
    );
  }
}

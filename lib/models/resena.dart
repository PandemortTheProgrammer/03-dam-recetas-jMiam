class Resena {
  final int? id;
  final int recetaId;
  final int usuarioId;
  final int valoracion;
  final String resena;

  const Resena({
    this.id,
    required this.recetaId,
    this.usuarioId = 1,
    required this.valoracion,
    required this.resena,
  });

  factory Resena.fromMap(Map<String, Object?> map) {
    return Resena(
      id: map['id'] as int,
      recetaId: map['recetaId'] as int,
      usuarioId: map['usuarioId'] as int,
      valoracion: map['valoracion'] as int,
      resena: map['resena'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'recetaId': recetaId,
      'usuarioId': usuarioId,
      'valoracion': valoracion,
      'resena': resena,
    };
  }
}

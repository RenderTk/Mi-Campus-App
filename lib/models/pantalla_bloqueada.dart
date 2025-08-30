import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pantalla_bloqueada.g.dart';

@CopyWith()
@JsonSerializable()
class PantallaBloqueada {
  @JsonKey(name: 'TITULO')
  String? titulo;

  @JsonKey(name: 'MENSAJE')
  String? mensaje;

  @JsonKey(name: 'PAGINAS')
  String? paginas;

  @JsonKey(name: 'RESULTADO', fromJson: _boolFromJson)
  bool? resultado;

  @JsonKey(name: 'BLOQUEAR', fromJson: _boolFromJson)
  bool? bloquear;

  PantallaBloqueada({
    this.titulo,
    this.mensaje,
    this.paginas,
    this.resultado,
    this.bloquear,
  });

  factory PantallaBloqueada.fromJson(Map<String, dynamic> json) =>
      _$PantallaBloqueadaFromJson(json);

  Map<String, dynamic> toJson() => _$PantallaBloqueadaToJson(this);

  // Método de conversión personalizado para booleanos
  static bool? _boolFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      final intValue = int.tryParse(value);
      return intValue == 1;
    }
    return null;
  }

  /// Getters basados en la propiedad BLOQUEAR
  bool get retiros => (paginas == "Retiros") ? (bloquear == true) : false;

  bool get suficienciaEstudiante =>
      (paginas == "Suficiencia_estudiante") ? (bloquear == true) : false;

  bool get extraordinario =>
      (paginas == "Extraordinario") ? (bloquear == true) : false;

  bool get cambios => (paginas == "Cambios") ? (bloquear == true) : false;

  bool get matricula => (paginas == "Matricula") ? (bloquear == true) : false;
}

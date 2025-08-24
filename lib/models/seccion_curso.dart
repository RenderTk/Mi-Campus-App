import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seccion_curso.g.dart';

@CopyWith()
@JsonSerializable()
class SeccionCurso {
  @JsonKey(name: 'ID_SECCION_CLIENTE')
  int? idSeccionCliente;

  @JsonKey(name: 'CODIGO_CURSO')
  String? codigoCurso;

  @JsonKey(name: 'DESCRIPCION_CURSO')
  String? descripcionCurso;

  @JsonKey(name: 'NUMERO_SECCION')
  int? numeroSeccion;

  @JsonKey(name: 'INICIO')
  String? inicio;

  @JsonKey(name: 'FIN')
  String? fin;

  @JsonKey(name: 'ESTADO')
  String? estado;

  @JsonKey(name: 'DIA')
  String? dia;

  @JsonKey(name: 'AULA')
  String? aula;

  @JsonKey(name: 'GRUPO')
  String? grupo;

  @JsonKey(name: 'URL')
  String? url;

  SeccionCurso({
    this.idSeccionCliente,
    this.codigoCurso,
    this.descripcionCurso,
    this.numeroSeccion,
    this.inicio,
    this.fin,
    this.estado,
    this.dia,
    this.aula,
    this.grupo,
    this.url,
  });

  factory SeccionCurso.fromJson(Map<String, dynamic> json) =>
      _$SeccionCursoFromJson(json);

  Map<String, dynamic> toJson() => _$SeccionCursoToJson(this);

  /// Obtiene el día de la semana sin espacios adicionales
  String? get diaNormalizado => dia?.trim();

  /// Obtiene el aula sin espacios adicionales
  String? get aulaNormalizada => aula?.trim();

  /// Verifica si el curso está activo
  bool get estaActivo => estado == 'Activa';

  /// Verifica si es modalidad presencial
  bool get esPresencial => grupo == 'Presencial';

  /// Verifica si es por videoconferencia
  bool get esVirtual => grupo == 'Por Videoconferencia';

  /// Obtiene una representación legible del horario
  String? get horarioCompleto {
    if (inicio != null && fin != null) {
      return '$inicio - $fin';
    }
    return null;
  }

  /// Convierte el día de texto a número (1 = Lunes, 7 = Domingo)
  int? get numeroDia {
    if (dia == null) return null;
    final diaLimpio = dia!.trim().toLowerCase();
    switch (diaLimpio) {
      case 'lunes':
        return 1;
      case 'martes':
        return 2;
      case 'miércoles':
      case 'miercoles':
        return 3;
      case 'jueves':
        return 4;
      case 'viernes':
        return 5;
      case 'sábado':
      case 'sabado':
        return 6;
      case 'domingo':
        return 7;
      default:
        return null;
    }
  }

  /// Convierte la hora de texto (ej: "10:45AM") a DateTime para hoy
  DateTime? get proximaFechaClase {
    if (inicio == null || numeroDia == null) return null;

    try {
      // Parsear la hora
      final horaTexto = inicio!.toUpperCase();
      final esAM = horaTexto.contains('AM');
      final esPM = horaTexto.contains('PM');

      if (!esAM && !esPM) return null;

      final horaLimpia = horaTexto.replaceAll(RegExp(r'[AP]M'), '');
      final partes = horaLimpia.split(':');

      if (partes.length != 2) return null;

      int hora = int.parse(partes[0]);
      final minuto = int.parse(partes[1]);

      // Convertir a formato 24 horas
      if (esPM && hora != 12) hora += 12;
      if (esAM && hora == 12) hora = 0;

      // Obtener la fecha actual
      final ahora = DateTime.now();
      final hoy = DateTime(ahora.year, ahora.month, ahora.day);

      // Calcular cuántos días hasta la próxima clase
      final diaActual = ahora.weekday; // 1 = Lunes, 7 = Domingo
      int diasHasta = numeroDia! - diaActual;

      if (diasHasta < 0) {
        diasHasta += 7; // Próxima semana
      } else if (diasHasta == 0) {
        // Es hoy, verificar si ya pasó la hora
        final horaClase = DateTime(
          ahora.year,
          ahora.month,
          ahora.day,
          hora,
          minuto,
        );
        if (ahora.isAfter(horaClase)) {
          diasHasta = 7; // Próxima semana
        }
      }

      final fechaClase = hoy.add(Duration(days: diasHasta));
      return DateTime(
        fechaClase.year,
        fechaClase.month,
        fechaClase.day,
        hora,
        minuto,
      );
    } catch (e) {
      return null;
    }
  }

  /// Métodos helper estáticos
  static List<SeccionCurso> get cursosFiltrados => [];

  /// 1. Encuentra la próxima clase más cercana a partir de hoy
  static SeccionCurso? obtenerProximaClase(List<SeccionCurso> secciones) {
    if (secciones.isEmpty) return null;

    final ahora = DateTime.now();
    SeccionCurso? proximaClase;
    DateTime? fechaMasCercana;

    for (final seccion in secciones) {
      if (!seccion.estaActivo) continue; // Solo clases activas

      final fechaClase = seccion.proximaFechaClase;
      if (fechaClase == null) continue;

      // Solo considerar clases futuras
      if (fechaClase.isAfter(ahora)) {
        if (fechaMasCercana == null || fechaClase.isBefore(fechaMasCercana)) {
          fechaMasCercana = fechaClase;
          proximaClase = seccion;
        }
      }
    }

    return proximaClase;
  }

  /// 2. Calcula el tiempo restante hasta la próxima clase en formato corto
  static String calcularTiempoRestanteDeProximaClase(
    List<SeccionCurso> secciones,
  ) {
    final proximaClase = obtenerProximaClase(secciones);
    if (proximaClase == null) {
      return "Sin clases próximas";
    }

    final fechaClase = proximaClase.proximaFechaClase;
    if (fechaClase == null) {
      return "Fecha no disponible";
    }

    final ahora = DateTime.now();
    final diferencia = fechaClase.difference(ahora);

    if (diferencia.isNegative) {
      return "Clase iniciada";
    }

    final totalMinutos = diferencia.inMinutes;
    final totalHoras = diferencia.inHours;
    final dias = diferencia.inDays;

    if (dias > 0) {
      return "En ${dias}d";
    } else if (totalHoras > 0) {
      final minutosRestantes = totalMinutos - (totalHoras * 60);
      return "En ${totalHoras}h y ${minutosRestantes}min";
    } else {
      return "En ${totalMinutos}min";
    }
  }

  static String calcularTiempoRestante(SeccionCurso seccion) {
    final fechaClase = seccion.proximaFechaClase;
    if (fechaClase == null) {
      return "Fecha no disponible";
    }

    final ahora = DateTime.now();
    final diferencia = fechaClase.difference(ahora);

    if (diferencia.isNegative) {
      return "Clase iniciada";
    }

    final totalMinutos = diferencia.inMinutes;
    final totalHoras = diferencia.inHours;
    final dias = diferencia.inDays;

    if (dias > 0) {
      return "En ${dias}d";
    } else if (totalHoras > 0) {
      final minutosRestantes = totalMinutos - (totalHoras * 60);
      return "En ${totalHoras}h y ${minutosRestantes}min";
    } else {
      return "En ${totalMinutos}min";
    }
  }

  /// Método helper para obtener información completa de la próxima clase
  static Map<String, dynamic>? obtenerInfoProximaClase(
    List<SeccionCurso> secciones,
  ) {
    final proximaClase = obtenerProximaClase(secciones);
    if (proximaClase == null) return null;

    return {
      'seccion': proximaClase,
      'tiempoRestante': calcularTiempoRestanteDeProximaClase(secciones),
      'fechaClase': proximaClase.proximaFechaClase,
    };
  }
}

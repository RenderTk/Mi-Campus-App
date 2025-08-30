import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/carrera.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

const String progresoCarreraUrl = "obtenerporcentajecarrera/{codigo_alumno}";

const String totalClasesEnCarreraUrl =
    "actividades_coprogramaticas/planes/{codigo_alumno}/2";

const String clasesCompletadasUrl =
    "historial/total_cumplidos/{codigo_alumno}/{id_plan}";

const String horarioUrl =
    "Horariosalumno/obtener_horarios_alumno/{codigo_alumno}";

const String calificacionesUrl =
    "historial/informacion/{codigo_alumno}/{id_plan}";

const String puntosCoProgramaticosUrl =
    "actividades_coprogramaticas/alumno/historial/{codigo_alumno}/{id_plan}";

const String carreraIdPlanUrl =
    "actividades_coprogramaticas/planes/{codigo_alumno}/2";

const String promediosCalificacionesUrl =
    "historial/promedios/{codigo_alumno}/{id_plan}";

const String fotoCarnetAlumnoUrl = "obtenerfoto_carnet/{codigo_alumno}";

class StudentDataService {
  final _dioService = DioService();

  Future<String?> getFotoCarnetAlumno(String codigoAlumno) async {
    final url = fotoCarnetAlumnoUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = _dioService.getDio();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final String base64String = data[0]['FOTO'];
      String cleanBase64 = base64String
          .replaceAll('<FOTO>', '')
          .replaceAll('</FOTO>', '');

      return cleanBase64;
    } else {
      return null;
    }
  }

  Future<int> _getCarreraProgress(String codigoAlumno) async {
    final url = progresoCarreraUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = _dioService.getDio();
    final response = await dio.get<List<dynamic>>(url);

    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final int progress = (data[0]['PORCENTAJE'] as num).toInt();
      return progress;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<Map<String, double>> getPromediosCalificaciones(
    String codigoAlumno,
  ) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = promediosCalificacionesUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;

    if (data != null && data.isNotEmpty) {
      final promedioGraduacion = (data[0]['PROMEDIO_GRADUACION'] as num);
      final promedioHistorico = (data[0]['PROMEDIO_HISTORICO'] as num);

      return {
        "PROMEDIO_GRADUACION": promedioGraduacion.toDouble(),
        "PROMEDIO_HISTORICO": promedioHistorico.toDouble(),
      };
    } else {
      return {"PROMEDIO_GRADUACION": 0, "PROMEDIO_HISTORICO": 0};
    }
  }

  Future<int> _getTotalClasesCompletadas(String codigoAlumno) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = clasesCompletadasUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final int totalClasesCumplidas = (data[0]['TOTAL_CUMPLIDAS'] as num)
          .toInt();
      return totalClasesCumplidas;
    } else {
      return 0;
    }
  }

  Future<int> _getCarreraIdPlan(String codigoAlumno) async {
    final url = carreraIdPlanUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      return (data[0]['ID_PLAN'] as num).toInt();
    } else {
      return 0;
    }
  }

  Future<int> getPuntosCoProgramaticos(String codigoAlumno) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = puntosCoProgramaticosUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      int puntos = 0;
      for (var item in data) {
        puntos += (item['PUNTAJE'] as num).toInt();
      }
      return puntos;
    } else {
      return 0;
    }
  }

  Future<Carrera> getCarrera(String codigoAlumno) async {
    final url = totalClasesEnCarreraUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final totalClasesCumplidas = await _getTotalClasesCompletadas(
        codigoAlumno,
      );

      final progresoCarrera = await _getCarreraProgress(codigoAlumno);

      final int totalClases = (data[0]['TOTAL_CURSOS_PLAN'] as num).toInt();
      final String nombreCarrera = data[0]['DESCRIPCION_PLAN'];
      final promedios = await getPromediosCalificaciones(codigoAlumno);
      return Carrera(
        nombre: nombreCarrera,
        progresoCarrera: progresoCarrera,
        promedioGraduacion: promedios["PROMEDIO_GRADUACION"] ?? 0,
        promedioHistorico: promedios["PROMEDIO_HISTORICO"] ?? 0,
        totalClasesCompletadas: totalClasesCumplidas,
        totalClases: totalClases,
      );
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<SeccionCurso>> getHorarioAlumno(String codigoAlumno) async {
    final url = horarioUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null) {
      return data.map((e) => SeccionCurso.fromJson(e)).toList();
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<CalificacionCurso>> getCalificacionesAlumno(
    String codigoAlumno,
  ) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = calificacionesUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;

    data?.removeWhere((e) => e['ESTATUS'] == "Equivalencia");

    if (data != null) {
      final calificaciones = data
          .map((e) => CalificacionCurso.fromJson(e))
          .toList();
      return calificaciones;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<String?> descargarCalendarioAlumno(
    String url,
    String codigoAlumno,
  ) async {
    try {
      final dio = _dioService.getDio();

      // Download the ICS file
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // The response.data should contain the ICS file as text
        // String icsContent = utf8.decode(response.data);
        String icsContent = rawicsContent;

        // Basic validation that it's an ICS file
        if (icsContent.contains('BEGIN:VCALENDAR') &&
            icsContent.contains('END:VCALENDAR')) {
          //save calendar url
          await SecureCredentialStorageService.setCalendarUrl(
            url,
            codigoAlumno,
          );

          return icsContent;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

const rawicsContent = """ 
BEGIN:VCALENDAR
METHOD:PUBLISH
PRODID:-//Moodle Pty Ltd//NONSGML Moodle Version 2023042401.05//EN
VERSION:2.0
BEGIN:VEVENT
UID:448659@virtual.usap.edu
SUMMARY:Vencimiento de SEMANA 10
DESCRIPTION:GRAFICAS DE FUNCIONES TRIGONOMETRICAS REALES SECCION 6.5\n\nANT
	ES DEBERA VER EL VIDEO 022 DELC ANAL RECOMENDADO\n\nDEBERA REALIZAR LOS SIG
	UIENTES EJERCICIOS\nEJERCICIOS DEL 30 AL 40\n\nESTIMADO ESTUDIANTE.\nA CONT
	INUACIÓN SE PRESENTA LA ACTIVIDAD DENOMINADA  GRAFICAS TRIGONOMETRICAS COMO
	 PARTE ACUMULATIVA DE LA TERCERA EVALUACIÓN LA CUAL DEBERÁ REALIZAR  SIGUIE
	NDO LAS SIGUIENTES INSTRUCCIONES:\n\nCON EL FIN DE DESARROLLAR LA ACTIVIDAD
	 SIGA LAS SIGUIENTES INSTRUCCIONES:\n1.      ELABORE UNA PORTADA CON SUS DA
	TOS.\n2.      EL TRABAJO DEBE SER LEGIBLE Y TENER BUENA CLARIDAD AL MOMENTO
	 DE PRESENTARLO.\n3.      SE REVISARÁ LA CANTIDAD DE EJERCICIOS ENTREGADOS.
	\n4.      NO SE ACEPTAN TRABAJOS IDÉNTICOS (MISMAS FOTOGRAFÍAS Y MISMA LETR
	A).\n5.      LA ACTIVIDAD SOLO PODRÁ SUBIRLA 1 VEZ A LA PLATAFORMA POR LO Q
	UE SE LE SUGIERE ESTE SEGURO DEL ARCHIVO QUE SUBIRÁ A LA MISMA.\n6.      EN
	TREGUE SU DOCUMENTO EN PDF (TOMAR FOTOGRAFIAS, LUEGO LAS PEGA EN WORD Y FI
	NALMENTE PASA SU ARCHIVO A PDF)\n \nCUANDO YA TENGA SU TRABAJO LISTO EN WOR
	D GUARDE SU DOCUMENTO EN FORMATO PDF EN UNA COMPUTADORA O EN UNA MEMORIA US
	B DE LA SIGUIENTE FORMA:\nSUAPELLIDO_SUNOMBRE_ACTIVIDADX.PDF AL GUARDARLOS 
	QUEDARÁ DE LA SIGUIENTE FORMA:\nEJEMPLO: PEREZ_CARLOS_ACTIVIDADX.PDF\nAL FI
	NALIZAR PARA SUBIR SU TRABAJO A LA PLATAFORMA PRESIONE EL BOTÓN AGREGAR ENT
	REGA LUEGO LOCALICE EL DOCUMENTO EN SU COMPUTADORA O MEMORIA USB Y ARRÁSTRE
	LO HASTA EL CUADRANTE DE LA FLECHA AZUL, ASEGÚRESE QUE QUEDE SUBIDO A ESTE
	 CUADRANTE Y SEGUIDAMENTE HAGA CLICK EN GUARDAR CAMBIOS.\n\n \n\n
	
CLASS:PUBLIC
LAST-MODIFIED:20250804T051114Z
DTSTAMP:20250813T025910Z
DTSTART:20250809T060000Z
DTEND:20250809T060000Z
CATEGORIES:MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:448661@virtual.usap.edu
SUMMARY:Vencimiento de Semana 12-ECUACIONES TRIGONOMETRICAS
DESCRIPTION:ECUACIONES  TRIGONOMETRICAS  SECCION 7.2\n\nDEBERA EN PRIMER LU
	GAR VER LOS VIDEOS 023 Y 024 DE LA LISTA DE VIDEOS EN EL CANAL RECOMENDADO
	n\nDEBERA REALIZAR LOS SIGUIENTES EJERCICIOS\nEJERCICIOS DEL 15 AL 30\n\nEJ
	ERCICIOS DEL 40 AL 50\n\nESTIMADO ESTUDIANTE.\nA CONTINUACIÓN SE PRESENTA L
	A ACTIVIDAD DENOMINADA ECUACIONES  TRIGONOMETRICAS COMO PARTE ACUMULATIVA D
	E LA TERCERA EVALUACIÓN LA CUAL DEBERÁ REALIZAR  SIGUIENDO LAS SIGUIENTES I
	NSTRUCCIONES:\n\nCON EL FIN DE DESARROLLAR LA ACTIVIDAD SIGA LAS SIGUIENTES
	 INSTRUCCIONES:\n1.      ELABORE UNA PORTADA CON SUS DATOS.\n2.      EL TRA
	BAJO DEBE SER LEGIBLE Y TENER BUENA CLARIDAD AL MOMENTO DE PRESENTARLO.\n3.
	      SE REVISARÁ LA CANTIDAD DE EJERCICIOS ENTREGADOS.\n4.      NO SE ACEP
	TAN TRABAJOS IDÉNTICOS (MISMAS FOTOGRAFÍAS Y MISMA LETRA).\n5.      LA ACTI
	VIDAD SOLO PODRÁ SUBIRLA 1 VEZ A LA PLATAFORMA POR LO QUE SE LE SUGIERE EST
	E SEGURO DEL ARCHIVO QUE SUBIRÁ A LA MISMA.\n6.      ENTREGUE SU DOCUMENTO 
	EN PDF (TOMAR FOTOGRAFIAS, LUEGO LAS PEGA EN WORD Y FINALMENTE PASA SU ARC
	HIVO A PDF)\n \nCUANDO YA TENGA SU TRABAJO LISTO EN WORD GUARDE SU DOCUMENT
	O EN FORMATO PDF EN UNA COMPUTADORA O EN UNA MEMORIA USB DE LA SIGUIENTE FO
	RMA:\nSUAPELLIDO_SUNOMBRE_ACTIVIDADX.PDF AL GUARDARLOS QUEDARÁ DE LA SIGUIE
	NTE FORMA:\nEJEMPLO: PEREZ_CARLOS_ACTIVIDADX.PDF\nAL FINALIZAR PARA SUBIR S
	U TRABAJO A LA PLATAFORMA PRESIONE EL BOTÓN AGREGAR ENTREGA LUEGO LOCALICE 
	EL DOCUMENTO EN SU COMPUTADORA O MEMORIA USB Y ARRÁSTRELO HASTA EL CUADRANT
	E DE LA FLECHA AZUL, ASEGÚRESE QUE QUEDE SUBIDO A ESTE CUADRANTE Y SEGUIDA
	MENTE HAGA CLICK EN GUARDAR CAMBIOS.\n\n \n\n
	
CLASS:PUBLIC
LAST-MODIFIED:20250804T050717Z
DTSTAMP:20250813T025910Z
DTSTART:20250809T060000Z
DTEND:20250809T060000Z
CATEGORIES:MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:448761@virtual.usap.edu
SUMMARY:VIDEOCONFERENCIA MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DM
	V 2025 - 2 está programado para
	
DESCRIPTION:
CLASS:PUBLIC
LAST-MODIFIED:20250509T141510Z
DTSTAMP:20250813T025910Z
DTSTART:20250809T060000Z
DTEND:20250809T060000Z
CATEGORIES:MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:508057@virtual.usap.edu
SUMMARY:Vencimiento de TAREA#4: UNIT 7 + SPEECH
DESCRIPTION:PLEASE TAKE A SCREENSHOT OF UNIT 7 FROM GDE35 CANVAS PLATFORM A
	ND PASTE YOUR CANVA SPEECH LINK PRESENTATION.\n\nUNIT 7: SOCIOLOGY\n\nDON'T
	 FORGET TO RENAME YOUR FILE AS NOMBRE_APELLIDO_TAREA#4 \n\nSPEECH CANVA EXA
	MPLE [1]\n\nCANVAS PLATFORM\n\nCLICK HERE [2]\n\n\n\nLinks:\n------\n[1] ht
	tps://www.canva.com/design/DAGu-FVa720/dAHYJQaR63XQZG8tH8FV_Q/edit?utm_cont
	ent=DAGu-FVa720&amp;utm_campaign=designshare&amp;utm_medium=link2&amp;ut
	m_source=sharebutton\n[2] https://educa.usap.edu/\n
	
CLASS:PUBLIC
LAST-MODIFIED:20250803T144551Z
DTSTAMP:20250813T025910Z
DTSTART:20250810T055900Z
DTEND:20250810T055900Z
CATEGORIES:LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:451196@virtual.usap.edu
SUMMARY:VIDEOCONFERENCIA LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2 est
	á programado para
	
DESCRIPTION:CLICK HERE TO JOIN THE CLASS ON GOOGLE MEET.\n\n
CLASS:PUBLIC
LAST-MODIFIED:20250510T005655Z
DTSTAMP:20250813T025910Z
DTSTART:20250810T131500Z
DTEND:20250810T144500Z
CATEGORIES:LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:448762@virtual.usap.edu
SUMMARY:VIDEOCONFERENCIA MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DM
	V 2025 - 2 está programado para
	
DESCRIPTION:
CLASS:PUBLIC
LAST-MODIFIED:20250509T141510Z
DTSTAMP:20250813T025910Z
DTSTART:20250816T060000Z
DTEND:20250816T060000Z
CATEGORIES:MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:451197@virtual.usap.edu
SUMMARY:VIDEOCONFERENCIA LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2 est
	á programado para
	
DESCRIPTION:CLICK HERE TO JOIN THE CLASS ON GOOGLE MEET.\n\n
CLASS:PUBLIC
LAST-MODIFIED:20250510T005655Z
DTSTAMP:20250813T025910Z
DTSTART:20250817T131500Z
DTEND:20250817T144500Z
CATEGORIES:LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:508698@virtual.usap.edu
SUMMARY:Vencimiento de WEBSITE (FAMOUS BLOG PROJECT)
DESCRIPTION:READ THE INSTRUCTIONS CAREFULLY:\nEXAM ON MONDAY AUGUST 17TH FR
	OM 7:15 AM TO 8:45 AM\nWEBSITE (FAMOUS BLOG) FROM CANVA\nUPLOAD YOUR SCREEN
	SHOT PRESENTING YOUR PROJECT LIVE AND PASTE YOUR CANVA LINK IN THE COMMENT 
	BELOW.\nRENAME YOUR SCREENSHOT AS NOMBRE_APELLIDO_WEBSITE\nTOTAL: 30 POINTS
	\n\n
	
CLASS:PUBLIC
LAST-MODIFIED:20250808T155225Z
DTSTAMP:20250813T025910Z
DTSTART:20250817T144500Z
DTEND:20250817T144500Z
CATEGORIES:LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:508695@virtual.usap.edu
SUMMARY:FORO DISCUSION DE NOTAS PARCIAL 3 Y 4 P. 2025-2 pendiente
DESCRIPTION:LEER DETENIDAMENTE LAS INSTRUCCIONES:\n\nFAVOR INGRESAR AL LINK
	 DE ABAJO, VERIFICAR Y FIRMAR SU NOTA, LUEGO COMENTAR EN EL FORO "ESTOY D
	E ACUERDO CON MIS NOTAS PARCIAL 3 Y 4"\n\nVERIFIQUE SU NOTA AQUI [1]\n\nIMP
	ORTANTE: NO OLVIDAR RESPONDER EN EL FORO.\n\n\n\nLinks:\n------\n[1] https:
	//drive.google.com/drive/folders/1KzxtvZ4qla3odaVlnGhvT2H2aF0MV-ys?usp=shar
	ing\n
	
CLASS:PUBLIC
LAST-MODIFIED:20250808T153412Z
DTSTAMP:20250813T025910Z
DTSTART:20250819T055900Z
DTEND:20250819T055900Z
CATEGORIES:LE-103-CN - INGLÉS III Seccion-21 DMV 2025 - 2
END:VEVENT
BEGIN:VEVENT
UID:448763@virtual.usap.edu
SUMMARY:VIDEOCONFERENCIA MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DM
	V 2025 - 2 está programado para
	
DESCRIPTION:
CLASS:PUBLIC
LAST-MODIFIED:20250509T141510Z
DTSTAMP:20250813T025910Z
DTSTART:20250823T060000Z
DTEND:20250823T060000Z
CATEGORIES:MM-202-CN - GEOMETRÍA Y TRIGONOMETRÍA Seccion-3 DMV 2025 - 2
END:VEVENT
END:VCALENDAR
""";

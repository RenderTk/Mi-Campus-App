import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/models/pantalla_bloqueada.dart';
import 'package:mi_campus_app/providers/user_provider.dart';
import 'package:mi_campus_app/services/permissions_service.dart';

enum PantallasBloqueadas {
  retiros,
  suficienciaEstudiante,
  extraordinario,
  cambios,
  matricula,
}

class PantallasBloqueadasNotifier
    extends AsyncNotifier<List<PantallaBloqueada>> {
  final _permissionsService = PermissionsService();

  @override
  Future<List<PantallaBloqueada>> build() async {
    final user = await ref.watch(userProvider.future);
    if (user == null) {
      throw Exception('User not found');
    }

    final pantallasBloqueadas = await _permissionsService
        .getPantallasBloqueadas(user.id);
    return pantallasBloqueadas;
  }

  bool isPantallaBloqueada(PantallasBloqueadas pantalla) {
    final pantallasBloqueadas = state.value;

    if (pantallasBloqueadas == null) return true;

    for (final p in pantallasBloqueadas) {
      if (pantalla == PantallasBloqueadas.retiros && p.paginas == "Retiros") {
        return p.bloquear == true;
      }
      if (pantalla == PantallasBloqueadas.suficienciaEstudiante &&
          p.paginas == "Suficiencia_estudiante") {
        return p.bloquear == true;
      }
      if (pantalla == PantallasBloqueadas.extraordinario &&
          p.paginas == "Extraordinario") {
        return p.bloquear == true;
      }
      if (pantalla == PantallasBloqueadas.cambios && p.paginas == "Cambios") {
        return p.bloquear == true;
      }
      if (pantalla == PantallasBloqueadas.matricula &&
          p.paginas == "Matricula") {
        return p.bloquear == true;
      }
    }

    return false; // Si no encuentra la pantalla, no está bloqueada
  }

  /// Refresca las pantallas bloqueadas
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final pantallasBloqueadasProvider =
    AsyncNotifierProvider<PantallasBloqueadasNotifier, List<PantallaBloqueada>>(
      () => PantallasBloqueadasNotifier(),
    );

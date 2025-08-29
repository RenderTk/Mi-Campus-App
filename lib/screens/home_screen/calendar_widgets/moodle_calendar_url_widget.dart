import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/calendar_event.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';
import 'package:usap_mobile/providers/calendar_navigation_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/student_data_service.dart';
import 'package:usap_mobile/utils/ics_parser.dart';
import 'package:usap_mobile/utils/snackbar_helper.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/screens/home_screen/calendar_widgets/calendar_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class MoodleCalendarUrlWidget extends ConsumerStatefulWidget {
  const MoodleCalendarUrlWidget({super.key});

  @override
  ConsumerState<MoodleCalendarUrlWidget> createState() =>
      _MoodleCalendarUrlWidgetState();
}

class _MoodleCalendarUrlWidgetState
    extends ConsumerState<MoodleCalendarUrlWidget> {
  final _formKey = GlobalKey<FormState>();
  final _urlTextController = TextEditingController();
  final _studentDataService = StudentDataService();
  final _icsParser = IcsParser();
  int? eventsToBeInsertedCount;
  final List<CalendarEvent> loadedEventsFromUrl = [];
  bool isLoading = false;

  @override
  void dispose() {
    _urlTextController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    // Verifica si la URL fue proporcionada y no está vacía
    if (value == null || value.trim().isEmpty) {
      return 'La URL es obligatoria';
    }

    final url = value.trim();

    try {
      // Parsea la URL usando Uri.parse
      final uri = Uri.parse(url);

      // Solo https permitido
      if (uri.scheme.toLowerCase() != 'https') {
        return 'La URL debe usar el protocolo https://';
      }

      if (!['http', 'https'].contains(uri.scheme.toLowerCase())) {
        return 'La URL debe usar el protocolo http o https';
      }
      // Verificar que contenga el path requerido
      if (!uri.path.contains('/calendar/export_execute.php')) {
        return 'La URL es invalida';
      }
      // Verifica si el host existe y es válido
      if (uri.host.isEmpty) {
        return 'La URL debe tener un nombre de host válido';
      }

      // Valida la estructura del dominio
      final hostname = uri.host.toLowerCase();

      // Expresión regular básica para dominio
      final domainRegex = RegExp(
        r'^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$',
        caseSensitive: false,
      );

      if (!domainRegex.hasMatch(hostname)) {
        return 'Formato de dominio inválido';
      }

      if (hostname.toLowerCase() != 'virtual.usap.edu') {
        return 'Dominio debe ser virtual.usap.edu';
      }

      // Verifica que el dominio tenga al menos un punto (no solo localhost)
      if (!hostname.contains('.') && hostname != 'localhost') {
        return 'El dominio debe incluir un dominio de nivel superior (ejemplo: .com, .org)';
      }

      // Verifica longitud válida del dominio de nivel superior (2-6 caracteres)
      final parts = hostname.split('.');
      if (parts.isNotEmpty) {
        final tld = parts.last;
        if (tld.length < 2 || tld.length > 6) {
          return 'Dominio de nivel superior inválido';
        }
      }

      // Revisiones adicionales para patrones sospechosos
      if (hostname.startsWith('.') || hostname.endsWith('.')) {
        return 'Formato de dominio inválido';
      }

      if (hostname.contains('..')) {
        return 'Formato de dominio inválido';
      }

      // La URL es válida
      return null;
    } catch (e) {
      return 'Formato de URL inválido';
    }
  }

  Future<void> onSaveEvents() async {
    try {
      //save the new events
      await ref
          .read(calendarEventsProvider.notifier)
          .addEvents(loadedEventsFromUrl);

      //to navigate to calendar screen
      ref.read(calendarNavigationProvider.notifier).showCalendar();
    } finally {
      setState(() {
        eventsToBeInsertedCount = null;
        loadedEventsFromUrl.clear();
        _urlTextController.clear();
      });
    }
  }

  Future<void> _onCalendarDownload() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final rawIcsContent = await _studentDataService.descargarCalendarioAlumno(
        _urlTextController.text,
      );

      if (rawIcsContent == null) {
        if (!mounted) {
          return;
        }
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: "No se pudo obtener el calendario",
          type: SnackbarType.error,
        );
        return;
      }

      //if success
      final events = _icsParser.parseRawIcsDataToCalendarEvents(rawIcsContent);
      eventsToBeInsertedCount = ref
          .read(calendarEventsProvider.notifier)
          .countNewEventToBeAdded(events);

      final uniqueEvents = ref
          .read(calendarEventsProvider.notifier)
          .removeDuplicateEvents(events);

      loadedEventsFromUrl.addAll(uniqueEvents);
    } catch (e) {
      if (!mounted) {
        return;
      }
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "Ocurrio un error al cargar el calendario. Intente mas tarde.",
        type: SnackbarType.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAddNewEventsButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info, color: Colors.blue, size: 20),
            const SizedBox(width: 10),
            Text(
              (eventsToBeInsertedCount ?? 0) == 0
                  ? "No hay nuevos eventos para guardar"
                  : "Se encontraron $eventsToBeInsertedCount nuevos eventos",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if ((eventsToBeInsertedCount ?? 0) > 0)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async => onSaveEvents(),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              child: const Text("Guardar"),
            ),
          ),
      ],
    );
  }

  Widget _buildUrlInputCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Agrega tu calendario",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 25.0),
              Text(
                "URL del calendario",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _urlTextController,
                validator: _validateUrl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText:
                      "https://virtual.usap.edu/calendar/export_execute.php?userid=12345",
                  suffixIcon: IconButton(
                    onPressed: () => _urlTextController.clear(),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              if (eventsToBeInsertedCount == null ||
                  (eventsToBeInsertedCount ?? 0) == 0) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async =>
                        isLoading ? () {} : _onCalendarDownload(),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Descargando..."),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : const Text("Cargar calendario"),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              if (eventsToBeInsertedCount != null) _buildAddNewEventsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowToGetCalendarCard(BuildContext context) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "¿Cómo obtener el calendario?",
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text(
                "1. Ve a tu calendario de Moodle (virtual.usap.edu)",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                "2. Haz clic en Importar o exportar calendarios",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                "3. Haz clic en Exportar calendario",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                "4. En 'Eventos a exportar' escoge Todos los eventos",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                "5. En 'Periodo de tiempo' escoge 60 días recientes y próximos",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Text(
                "6. Haz clic en Obtener URL del calendario",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(List<CalendarEvent> calendarEvents) {
    final showCalendar = ref
        .watch(calendarNavigationProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);

    if (showCalendar) {
      return const CalendarWidget();
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today, size: 50),
              ),
              const SizedBox(height: 10),
              Text(
                "Calendario de Moodle",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Conecta tu calendario para ver tus actividades.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              _buildUrlInputCard(context),
              const SizedBox(height: 10),
              _buildHowToGetCalendarCard(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarEvents = ref.watch(calendarEventsProvider);

    return calendarEvents.when(
      data: (calendarEvents) => _buildSuccessState(calendarEvents),
      error: (error, stackTrace) {
        // si se intento refrescar el token y no se pudo, se cierra la sesion
        // y se redirige al login
        if (error is TokenRefreshFailedException) {
          return SessionExpiredWidget(
            onLogin: () async {
              await ref.read(userProvider.notifier).logOut();
            },
          );
        }

        return ErrorStateWidget(
          errorMessage:
              "Ocurrio un error al cargar los eventos de su calendario. Intente mas tarde.",
          onRetry: () async => ref.invalidate(calendarEventsProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:usap_mobile/models/student.dart';

Uint8List? fotoAsbase64ToUint8List(String? base64String) {
  if (base64String == null) return null;

  try {
    return base64Decode(base64String);
  } catch (e) {
    return null;
  }
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;

  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

String get getCurrentPeriodo {
  final now = DateTime.now();
  final month = now.month;

  int periodo;

  if (month >= 1 && month <= 4) {
    periodo = 1;
  } else if (month >= 5 && month <= 8) {
    periodo = 2;
  } else {
    periodo = 3;
  }

  return "$periodo/3";
}

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    final studentNames = student.user.name.split(" ");

    Uint8List? fotoBytes = fotoAsbase64ToUint8List(student.fotoBase64);

    final lightModeFallbackFotoUrl =
        "https://avatar.iran.liara.run/username?username=${studentNames[0]}+${studentNames[studentNames.length - 1]}&background=0d47a1&color=bbdefb";
    // Dark blue background (#0d47a1), light blue text (#bbdefb)

    final darkModeAvatarUrl =
        "https://avatar.iran.liara.run/username?username=${studentNames[0]}+${studentNames[studentNames.length - 1]}&background=bbdefb&color=0d47a1";
    // Light blue background (#bbdefb), dark blue text (#0d47a1)

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                fotoBytes != null
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(fotoBytes),
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            Theme.of(context).brightness == Brightness.dark
                            ? darkModeAvatarUrl
                            : lightModeFallbackFotoUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 30,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${studentNames[0]} ${studentNames[studentNames.length - 1]}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(student.user.email),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 15,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Universidad De San Pedro Sula",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      "Estudiando",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      "Periodo",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            toTitleCase(student.carrera.nombre),
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          getCurrentPeriodo,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Divider(color: Theme.of(context).colorScheme.tertiary),
                    Row(
                      children: [
                        Text(
                          "Puntos co-programáticos",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const Spacer(),
                        Text(
                          student.puntosCoProgramaticos.toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          customBorder: const CircleBorder(),
                          child: Icon(
                            Icons.launch,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onTap: () => {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

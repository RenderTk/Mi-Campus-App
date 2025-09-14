import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Uint8List? fotoAsbase64ToUint8List(String? base64String) {
  if (base64String == null) return null;

  try {
    return base64Decode(base64String);
  } catch (e) {
    return null;
  }
}

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    super.key,
    required this.fotoAsBase64,
    required this.firstName,
    required this.lastName,
  });
  final String? fotoAsBase64;
  final String? firstName;
  final String? lastName;

  @override
  Widget build(BuildContext context) {
    Uint8List? fotoBytes = fotoAsbase64ToUint8List(fotoAsBase64);

    final lightModeFallbackFotoUrl =
        "https://avatar.iran.liara.run/username?username=$firstName+$lastName]&background=0d47a1&color=bbdefb";
    // Dark blue background (#0d47a1), light blue text (#bbdefb)

    final darkModeAvatarUrl =
        "https://avatar.iran.liara.run/username?username=$firstName+$lastName&background=bbdefb&color=0d47a1";
    // Light blue background (#bbdefb), dark blue text (#0d47a1)

    return fotoBytes != null
        ? CircleAvatar(radius: 30, backgroundImage: MemoryImage(fotoBytes))
        : CachedNetworkImage(
            imageUrl: Theme.of(context).brightness == Brightness.dark
                ? darkModeAvatarUrl
                : lightModeFallbackFotoUrl,
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(radius: 30, backgroundImage: imageProvider),
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
  }
}

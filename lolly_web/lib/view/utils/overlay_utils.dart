import 'package:flutter/material.dart';

OverlayEntry? overlayEntry;

void showProfileOverlay(BuildContext context, String username, String email, String profileImage) {
  if (overlayEntry != null) return;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            overlayEntry?.remove();
            overlayEntry = null;
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          top: 43,
          right: 45,
          child: Material(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                    child: profileImage.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      overlayEntry?.remove();
                      overlayEntry = null;
                    },
                    child: const Text('Chỉnh sửa hồ sơ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Overlay.of(context).insert(overlayEntry!);
  });
}
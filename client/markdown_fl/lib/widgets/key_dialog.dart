import 'package:flutter/material.dart';

class KeyDialog extends StatelessWidget {
  final String title;
  final String hintText;
  final Function(String key) onSubmit;

  const KeyDialog({
    super.key,
    required this.title,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onSubmit(controller.text);
            Navigator.pop(context);
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
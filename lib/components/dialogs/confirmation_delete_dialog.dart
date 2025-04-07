import 'package:flutter/material.dart';

class ConfirmDeletionDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onDelete;

  const ConfirmDeletionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

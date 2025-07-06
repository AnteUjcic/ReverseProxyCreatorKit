import 'package:flutter/material.dart';

class DeleteUserButton extends StatelessWidget {
  final String userFullName;
  final Future<void> Function(String fullName) onDelete;
  final VoidCallback onDeleted;

  const DeleteUserButton({
    super.key,
    required this.userFullName,
    required this.onDelete,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Izbriši korisnika'),
            content: Text('Jeste li sigurni da želite izbrisati $userFullName?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Odustani'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Izbriši', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await onDelete(userFullName);
          onDeleted();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$userFullName izbrisan.')),
          );
        }
      },
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text('Izbriši korisnika', style: TextStyle(color: Colors.red)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
      ),
    );
  }
}


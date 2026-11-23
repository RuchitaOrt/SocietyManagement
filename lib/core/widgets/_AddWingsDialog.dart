
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonButton.dart';

class AddWingsDialog extends StatefulWidget {
  const AddWingsDialog();

  @override
  State<AddWingsDialog> createState() => _AddWingsDialogState();
}

class _AddWingsDialogState extends State<AddWingsDialog> {
  late final TextEditingController _wingController;

  @override
  void initState() {
    super.initState();
    // _wingController = TextEditingController();
    _wingController = TextEditingController(text: 'A, B, C, D');
  }

  @override
  void dispose() {
    _wingController.dispose();
    super.dispose();
  }

  void _saveWings() {
    final wings = _wingController.text
        .split(RegExp(r'[,\\n]+'))
        .map((wing) => wing.trim())
        .where((wing) => wing.isNotEmpty)
        .toSet()
        .toList();

    if (wings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one wing name')),
      );
      return;
    }

    Navigator.pop(context, wings);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Wings'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter wing names separated by commas or new lines.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _wingController,
              autofocus: true,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Example: A, B, C, D',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 110,
          child: CommonButton(text: 'Save', height: 42, onPressed: _saveWings),
        ),
      ],
    );
  }
}

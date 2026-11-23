
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/_AddWingsDialog.dart';

Future<List<String>?> showAddWingsDialog(
  BuildContext context,
) {
  return showDialog<List<String>>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return const AddWingsDialog();
    },
  );
}


import 'package:flutter/material.dart';

const Color rolePrimary = Color(0xFFE93691);
const Color roleText = Color(0xFF25324A);
const Color roleMuted = Color(0xFF71829F);

Future<void> showAddRoleDialog({
  required BuildContext context,
  String initialSociety = 'Jainam',
  String? initialRoleName,
  required Function(String roleName, String society) onSubmit,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AddRoleDialog(
        initialSociety: initialSociety,
        initialRoleName: initialRoleName,
        onSubmit: onSubmit,
      );
    },
  );
}

class AddRoleDialog extends StatefulWidget {
  final String initialSociety;
  final String? initialRoleName;
  final Function(String, String) onSubmit;

  const AddRoleDialog({
    super.key,
    required this.initialSociety,
    this.initialRoleName,
    required this.onSubmit,
  });

  @override
  State<AddRoleDialog> createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _societyController;
  late final TextEditingController _roleController;

  @override
  void initState() {
    super.initState();

    _societyController = TextEditingController(
      text: widget.initialSociety,
    );

    _roleController = TextEditingController(
      text: widget.initialRoleName ?? '',
    );
  }

  @override
  void dispose() {
    _societyController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialRoleName != null;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 525),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isEdit),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('ROLE INFORMATION'),
                    const SizedBox(height: 14),

                    _buildLabel('SOCIETY', required: true),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _societyController,
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 12,
                        color: roleMuted,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Select society',
                        prefixIcon: null,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Society is required'
                              : null,
                    ),

                    const SizedBox(height: 5),

                    const Row(
                      children: [
                        Icon(
                          Icons.lock,
                          size: 11,
                          color: Color(0xFFB5A45D),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Fixed to your account',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFB5C5DC),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _buildLabel('ROLE NAME', required: true),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _roleController,
                      autofocus: !isEdit,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                        fontSize: 12,
                        color: roleText,
                      ),
                      decoration: _inputDecoration(
                        hint: 'e.g. Security Guard, Accountant, Resident',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Role name is required';
                        }

                        if (value.trim().length < 2) {
                          return 'Enter at least 2 characters';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(isEdit),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 11),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFE8F1),
            Color(0xFFFFEBD8),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Text(
            isEdit ? 'Edit Role' : 'Add New Role',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: roleText,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Color(0xFFADB7C6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
            color: rolePrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(
          height: 1,
          color: Color(0xFFE8EDF4),
        ),
      ],
    );
  }

  Widget _buildLabel(
    String title, {
    bool required = false,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          color: Color(0xFF53627D),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: rolePrimary),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 11,
        color: Color(0xFFB5C5DC),
      ),
      prefixIcon: prefixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFDCE3EF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFDCE3EF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: rolePrimary,
        ),
      ),
      errorStyle: const TextStyle(fontSize: 10),
    );
  }

  Widget _buildFooter(bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 11, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF53627D),
              side: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: rolePrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            child: Text(
              isEdit ? 'Update Role' : 'Add Role',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      _roleController.text.trim(),
      _societyController.text.trim(),
    );

    Navigator.pop(context);
  }
}

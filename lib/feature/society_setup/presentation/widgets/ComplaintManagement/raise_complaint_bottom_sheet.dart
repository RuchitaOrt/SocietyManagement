import 'package:flutter/material.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_model.dart';

const Color complaintPrimary = Color(0xFFE93691);

Future<ComplaintModel?> showRaiseComplaintBottomSheet({
  required BuildContext context,
  required String societyName,
}) {
  return showModalBottomSheet<ComplaintModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => RaiseComplaintBottomSheet(
      societyName: societyName,
    ),
  );
}

class RaiseComplaintBottomSheet extends StatefulWidget {
  final String societyName;

  const RaiseComplaintBottomSheet({
    super.key,
    required this.societyName,
  });

  @override
  State<RaiseComplaintBottomSheet> createState() =>
      _RaiseComplaintBottomSheetState();
}

class _RaiseComplaintBottomSheetState
    extends State<RaiseComplaintBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController societyController;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'General';
  String selectedPriority = 'Medium';

  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);
  static const Color borderColor = Color(0xFFDCE4EF);

  @override
  void initState() {
    super.initState();

    societyController = TextEditingController(
      text: widget.societyName,
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFBCC9DA),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: complaintPrimary),
      ),
    );
  }

  Widget _label(String title, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFF53647C),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: title.toUpperCase()),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String title,
    required String hint,
    required TextEditingController controller,
    bool required = false,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, required: required),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
          decoration: _decoration(hint),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $title';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, required: required),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _decoration('Select $title'),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hintColor,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(
          title: 'Society',
          hint: widget.societyName,
          controller: societyController,
          readOnly: true,
        ),

        const SizedBox(height: 16),

        _dropdown(
          title: 'Category',
          value: selectedCategory,
          required: true,
          items: [
            'General',
            'Maintenance',
            'Security',
            'Cleaning',
            'Parking',
            'Noise',
            'Water',
            'Electricity',
            'Other',
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedCategory = value);
            }
          },
        ),

        const SizedBox(height: 16),

        _dropdown(
          title: 'Priority',
          value: selectedPriority,
          required: true,
          items: [
            'Low',
            'Medium',
            'High',
            'Urgent',
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedPriority = value);
            }
          },
        ),

        const SizedBox(height: 16),

        _field(
          title: 'Title',
          hint: 'Short complaint title',
          controller: titleController,
          required: true,
        ),

        const SizedBox(height: 16),

        _field(
          title: 'Description',
          hint: 'Describe the issue',
          controller: descriptionController,
          required: true,
          maxLines: 4,
        ),
      ],
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final complaint = ComplaintModel(
      society: widget.societyName,
      category: selectedCategory,
      priority: selectedPriority,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    Navigator.pop(context, complaint);
  }

  @override
  void dispose() {
    societyController.dispose();
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(18),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFCE8F1),
                      Color(0xFFFFEFDC),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Raise Complaint',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COMPLAINT INFORMATION',
                          style: TextStyle(
                            fontSize: 11,
                            color: complaintPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: borderColor),
                        const SizedBox(height: 14),
                        _formContent(),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.fromLTRB(
                  16, 12, 16, 14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
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
                        minimumSize: const Size(85, 44),
                        foregroundColor: const Color(0xFF53647C),
                        side: const BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: complaintPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(110, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
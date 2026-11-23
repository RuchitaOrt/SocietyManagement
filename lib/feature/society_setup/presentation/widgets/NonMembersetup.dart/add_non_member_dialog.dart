import 'package:flutter/material.dart';

import '../../bloc/NonMemberModel.dart';
import 'package:file_picker/file_picker.dart';
const Color primaryColor = Color(0xFFE93691);

Future<NonMemberModel?> showAddNonMemberDialog(
  BuildContext context,
) {
  return showModalBottomSheet<NonMemberModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const AddNonMemberDialog();
    },
  );
}

class AddNonMemberDialog extends StatefulWidget {
  const AddNonMemberDialog({super.key});

  @override
  State<AddNonMemberDialog> createState() =>
      _AddNonMemberDialogState();
}

class _AddNonMemberDialogState extends State<AddNonMemberDialog> {
  final _formKey = GlobalKey<FormState>();

  // final nameController = TextEditingController();
  // final contactController = TextEditingController();
  // final emailController = TextEditingController();
  // final financialYearController =
  //     TextEditingController(text: '2026-2027');
  // final address1Controller = TextEditingController();
  // final address2Controller = TextEditingController();
  // final aadhaarController = TextEditingController();
  // final panController = TextEditingController();
final nameController = TextEditingController(text: 'John Doe');
final contactController = TextEditingController(text: '9876543210');
final emailController = TextEditingController(text: 'john@example.com');
final financialYearController =
    TextEditingController(text: '2026-2027');
final address1Controller =
    TextEditingController(text: 'Mumbai');
final address2Controller = TextEditingController();
final aadhaarController = TextEditingController(text: '123456789012');
final panController = TextEditingController(text: 'ABCDE1234F');
  String? aadhaarFile;
  String? panFile;
  String? policeFile;

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
     final path = result.files.single.path ??
    result.files.single.name;

      if (type == 'aadhaar') {
        aadhaarFile = path;
      } else if (type == 'pan') {
        panFile = path;
      } else {
        policeFile = path;
      }
    });
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            children: [
              TextSpan(text: label),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator ??
              (required
                  ? (value) => value == null || value.trim().isEmpty
                      ? 'Please enter $label'
                      : null
                  : null),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFBCC9DA),
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFFDCE4EF),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFFDCE4EF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _attachment({
    required String label,
    required String? file,
    required VoidCallback onPick,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
            children: [
              TextSpan(text: label),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDCE4EF)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.upload_file_rounded,
                  size: 19,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    file == null
                        ? 'Choose file'
                        : file.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (file != null)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 17,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

void _submit() {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  final aadhaar = aadhaarController.text.trim();
  final pan = panController.text.trim().toUpperCase();
  final contact = contactController.text.trim();

  if (!RegExp(r'^\d{12}$').hasMatch(aadhaar)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter valid 12-digit Aadhaar number'),
      ),
    );
    return;
  }

  if (!RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(pan)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter valid PAN number'),
      ),
    );
    return;
  }

  if (!RegExp(r'^\d{10}$').hasMatch(contact)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter valid 10-digit mobile number'),
      ),
    );
    return;
  }

  // Required attachment validation
  // if (aadhaarFile == null || panFile == null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Please upload Aadhaar and PAN attachments'),
  //     ),
  //   );
  //   return;
  // }

  Navigator.pop(
    context,
    NonMemberModel(
      name: nameController.text.trim(),
      contactNumber: contact,
      email: emailController.text.trim(),
      financialYear: financialYearController.text.trim(),
      addressLine1: address1Controller.text.trim(),
      addressLine2: address2Controller.text.trim(),
      aadhaarNumber: aadhaar,
      panNumber: pan,
   aadhaarAttachment: aadhaarFile,
panAttachment: panFile,
policeNocAttachment: policeFile,
    ),
  );
}

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    financialYearController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    aadhaarController.dispose();
    panController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Container(
      height: screenHeight * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
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
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add Non-Member',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF202B43),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            label: 'Name',
                            controller: nameController,
                            hint: 'Full name',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _field(
                            label: 'Contact Number',
                            controller: contactController,
                            hint: '10-digit mobile',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            label: 'Email',
                            controller: emailController,
                            hint: 'email@example.com',
                            keyboardType:
                                TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Please enter email';
                              }

                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+$',
                              ).hasMatch(value.trim())) {
                                return 'Enter valid email';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _field(
                            label: 'Financial Year',
                            controller: financialYearController,
                            hint: '2026-2027',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _field(
                      label: 'Address Line 1',
                      controller: address1Controller,
                      hint: 'Flat / House address',
                    ),

                    const SizedBox(height: 15),

                    _field(
                      label: 'Address Line 2',
                      controller: address2Controller,
                      hint: 'Optional',
                      required: false,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            label: 'Aadhaar Number',
                            controller: aadhaarController,
                            hint: '12-digit Aadhaar',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _field(
                            label: 'PAN Number',
                            controller: panController,
                            hint: 'e.g. ABCDE1234F',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _attachment(
                            label: 'Aadhaar Attachment',
                            file: aadhaarFile,
                            onPick: () => _pickFile('aadhaar'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _attachment(
                            label: 'PAN Attachment',
                            file: panFile,
                            onPick: () => _pickFile('pan'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _attachment(
                      label: 'Police NOC Attachment (Optional)',
                      file: policeFile,
                      required: false,
                      onPick: () => _pickFile('police'),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),

          // BOTTOM BUTTONS
          Container(
            padding: const EdgeInsets.fromLTRB(
              16, 12, 16, 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text(
  'Add Non-Member',
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
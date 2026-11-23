import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/SoceityStaff/staff_category_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_model.dart';
import 'dart:io';

const Color staffPrimary = Color(0xFFE93691);
const Color staffTextColor = Color(0xFF202B43);
const Color staffHintColor = Color(0xFF91A0B8);
const Color staffBorderColor = Color(0xFFDCE4EF);

Future<StaffModel?> showAddStaffBottomSheet({
  required BuildContext context,
}) {
  final categoryBloc = context.read<StaffCategoryBloc>();
  final isDesktop = MediaQuery.of(context).size.width >= 600;

  if (isDesktop) {
    return showDialog<StaffModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: categoryBloc,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: const AddStaffBottomSheet(isDialog: true),
        ),
      ),
    );
  }

  return showModalBottomSheet<StaffModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: categoryBloc,
      child: const AddStaffBottomSheet(isDialog: false),
    ),
  );
}

class AddStaffBottomSheet extends StatefulWidget {
  final bool isDialog;

  const AddStaffBottomSheet({
    super.key,
    required this.isDialog,
  });

  @override
  State<AddStaffBottomSheet> createState() =>
      _AddStaffBottomSheetState();
}

class _AddStaffBottomSheetState extends State<AddStaffBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final aadhaarController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedCategory;
  String? selectedWing;

  DateTime? joiningDate;


  final List<String> wings = [
    'A',
    'B',
    'C',
    'D',
  ];

  final Map<String, List<String>> wingFlats = {
    'A': [
      'A - 101',
      'A - 102',
      'A - 201',
      'A - 202',
    ],
    'B': [
      'B - 101',
      'B - 102',
      'B - 201',
      'B - 202',
    ],
    'C': [
      'C - 101',
      'C - 102',
      'C - 201',
      'C - 202',
    ],
    'D': [
      'D - 101',
      'D - 102',
      'D - 201',
      'D - 202',
    ],
  };

  final Set<String> selectedFlats = {};

  String? staffPhotoPath;
  String? aadhaarDocumentPath;

  static const Color sectionBorder = Color(0xFFEDF1F6);
Widget _categoryDropdown() {
  return BlocBuilder<StaffCategoryBloc, StaffCategoryState>(
    builder: (context, state) {
      final categories = state.categories
          .map((category) => category.name)
          .toList();

      // Avoid a stale selection if a category was deleted.
      final currentValue = categories.contains(selectedCategory)
          ? selectedCategory
          : null;

      return _dropdown(
        title: 'Category',
        value: currentValue,
        items: categories,
        hint: state.isLoading
            ? 'Loading categories...'
            : 'Select category...',
        required: true,
        onChanged: (value) {
          setState(() => selectedCategory = value);
        },
      );
    },
  );
}
  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    aadhaarController.dispose();
    notesController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String hint, {
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: staffHintColor,
      ),
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 35,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: staffBorderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: staffBorderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: staffPrimary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _label(
    String title, {
    bool required = false,
  }) {
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
            TextSpan(text: title),
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
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.words,
          decoration: _decoration(hint),
          validator: validator ??
              (required
                  ? (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter $title';
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String title,
    required String? value,
    required List<String> items,
    required String hint,
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
          decoration: _decoration(hint),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: staffHintColor,
          ),
          validator: required
              ? (value) =>
                  value == null ? 'Please select $title' : null
              : null,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: staffTextColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: sectionBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: staffPrimary,
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: staffPrimary,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            color: staffBorderColor,
            height: 1,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _responsiveRow(
    Widget first,
    Widget second,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Column(
            children: [
              first,
              const SizedBox(height: 16),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  Future<void> _pickPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null &&
          result.files.single.path != null) {
        final file = result.files.single;

        if (file.size > 5 * 1024 * 1024) {
          _showMessage('Photo must be 5 MB or smaller');
          return;
        }

        setState(() {
          staffPhotoPath = file.path;
        });
      }
    } catch (_) {
      _showMessage('Unable to select photo');
    }
  }

  Future<void> _pickAadhaarDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
        ],
      );

      if (result != null &&
          result.files.single.path != null) {
        final file = result.files.single;

        if (file.size > 10 * 1024 * 1024) {
          _showMessage('Document must be 10 MB or smaller');
          return;
        }

        setState(() {
          aadhaarDocumentPath = file.path;
        });
      }
    } catch (_) {
      _showMessage('Unable to select document');
    }
  }

  Future<void> _pickJoiningDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: joiningDate ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: staffPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (date != null && mounted) {
      setState(() => joiningDate = date);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'dd/mm/yyyy';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Joining Date', required: true),
        InkWell(
          onTap: _pickJoiningDate,
          child: InputDecorator(
            decoration: _decoration('dd/mm/yyyy'),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(joiningDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: joiningDate == null
                          ? staffHintColor
                          : staffTextColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: staffTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _photoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Staff Photo'),
        Row(
          children: [
            Container(
              height: 66,
              width: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: staffBorderColor,
                ),
              ),
              child: staffPhotoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
  File(staffPhotoPath!),
  fit: BoxFit.cover,
)
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: staffHintColor,
                      size: 25,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: OutlinedButton(
                onPressed: _pickPhoto,
                style: OutlinedButton.styleFrom(
                  foregroundColor: staffTextColor,
                  side: const BorderSide(
                    color: staffPrimary,
                  ),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  staffPhotoPath == null
                      ? 'Choose Photo'
                      : 'Change Photo',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'JPG, PNG or WebP, up to 5 MB.',
          style: TextStyle(
            color: Color(0xFF7185A3),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _flatSelection() {
    final flats = selectedWing == null
        ? <String>[]
        : wingFlats[selectedWing] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Assigned Flats'),
        Container(
          height: 145,
          decoration: BoxDecoration(
            border: Border.all(color: staffBorderColor),
            borderRadius: BorderRadius.circular(9),
          ),
          child: selectedWing == null
              ? const Center(
                  child: Text(
                    'Select wing first',
                    style: TextStyle(
                      fontSize: 12,
                      color: staffHintColor,
                    ),
                  ),
                )
              : flats.isEmpty
                  ? const Center(
                      child: Text(
                        'No flats found',
                        style: TextStyle(
                          fontSize: 12,
                          color: staffHintColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: flats.length,
                      itemBuilder: (context, index) {
                        final flat = flats[index];

                        return CheckboxListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          value: selectedFlats.contains(flat),
                          activeColor: staffPrimary,
                          title: Text(
                            flat,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF53647C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                selectedFlats.add(flat);
                              } else {
                                selectedFlats.remove(flat);
                              }
                            });
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _documentUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Aadhaar Document'),
        OutlinedButton(
          onPressed: _pickAadhaarDocument,
          style: OutlinedButton.styleFrom(
            foregroundColor: staffTextColor,
            side: const BorderSide(
              color: staffBorderColor,
            ),
            minimumSize: const Size(
              double.infinity,
              44,
            ),
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.upload_file_outlined,
                size: 18,
                color: staffPrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  aadhaarDocumentPath == null
                      ? 'Choose File'
                      : aadhaarDocumentPath!.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'PDF or image, up to 10 MB.',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF7185A3),
          ),
        ),
      ],
    );
  }

  Widget _notesField() {
    return _field(
      title: 'Notes / Additional Info',
      hint: 'Any additional information...',
      controller: notesController,
      maxLines: 3,
    );
  }

  Widget _personalDetails() {
    return _section(
      title: 'Personal Details',
      icon: Icons.person_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _photoUpload(),
          const SizedBox(height: 16),
          _responsiveRow(
            _field(
              title: 'Full Name',
              hint: 'e.g., Sunita Devi',
              controller: fullNameController,
              required: true,
            ),
            _field(
              title: 'Mobile Number',
              hint: '10-digit number',
              controller: mobileController,
              required: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^[0-9]{10}$')
                        .hasMatch(value.trim())) {
                  return 'Enter valid 10 digit number';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _field(
            title: 'Address',
            hint: 'Permanent address',
            controller: addressController,
            required: true,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

 Widget _employmentDetails() {
  return _section(
    title: 'Employment & Assignment',
    icon: Icons.work_outline,
    child: Column(
      children: [
        _responsiveRow(
          _categoryDropdown(),
          _dateField(),
        ),
        const SizedBox(height: 16),
        _responsiveRow(
          _dropdown(
            title: 'Wing',
            value: selectedWing,
            items: wings,
            hint: 'Select wing...',
            onChanged: (value) {
              setState(() {
                selectedWing = value;
                selectedFlats.clear();
              });
            },
          ),
          _flatSelection(),
        ),
      ],
    ),
  );
}

  Widget _identityVerification() {
    return _section(
      title: 'Identity Verification',
      icon: Icons.badge_outlined,
      child: _responsiveRow(
        _field(
          title: 'Aadhaar Number',
          hint: '12-digit Aadhaar',
          controller: aadhaarController,
          required: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          validator: (value) {
            if (value == null ||
                !RegExp(r'^[0-9]{12}$')
                    .hasMatch(value.trim())) {
              return 'Enter valid 12 digit Aadhaar';
            }
            return null;
          },
        ),
        _documentUpload(),
      ),
    );
  }

  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _personalDetails(),
        const SizedBox(height: 16),
        _employmentDetails(),
        const SizedBox(height: 16),
        _identityVerification(),
        const SizedBox(height: 16),
        _notesField(),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (joiningDate == null) {
      _showMessage('Please select Joining Date');
      return;
    }

    final staff = StaffModel(
      fullName: fullNameController.text.trim(),
      mobileNumber: mobileController.text.trim(),
      address: addressController.text.trim(),
      category: selectedCategory!,
      joiningDate: joiningDate!,
      wing: selectedWing ?? '',
      assignedFlats: selectedFlats.toList(),
      aadhaarNumber: aadhaarController.text.trim(),
      staffPhotoPath: staffPhotoPath,
      aadhaarDocumentPath: aadhaarDocumentPath,
      notes: notesController.text.trim(),
    );

    Navigator.pop(context, staff);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: widget.isDialog
          ? EdgeInsets.zero
          : EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: widget.isDialog,
        child: Container(
          width: 560,
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: screenHeight * 0.90,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: _formContent(),
                  ),
                ),
              ),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCE8F1),
            Color(0xFFFFEFDC),
          ],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Staff Member',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: staffPrimary,
                  ),
                ),
                Text(
                  'Register a new staff or daily help worker',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7185A3),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(
                color: staffBorderColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(
              Icons.close,
              size: 18,
              color: Color(0xFF7185A3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
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
              side: const BorderSide(
                color: staffBorderColor,
              ),
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
              backgroundColor: staffPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size(100, 44),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text('Add Staff'),
          ),
        ],
      ),
    );
  }
}
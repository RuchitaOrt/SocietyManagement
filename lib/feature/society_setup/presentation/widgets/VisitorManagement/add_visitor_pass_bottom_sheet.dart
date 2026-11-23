
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';

const Color visitorPrimary = Color(0xFFE93691);

Future<VisitorPassModel?> showAddVisitorPassBottomSheet({
  required BuildContext context,
  required String societyName,
}) {
  return showModalBottomSheet<VisitorPassModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => AddVisitorPassBottomSheet(
      societyName: societyName,
    ),
  );
}

class AddVisitorPassBottomSheet extends StatefulWidget {
  final String societyName;

  const AddVisitorPassBottomSheet({
    super.key,
    required this.societyName,
  });

  @override
  State<AddVisitorPassBottomSheet> createState() =>
      _AddVisitorPassBottomSheetState();
}

class _AddVisitorPassBottomSheetState
    extends State<AddVisitorPassBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final visitorNameController = TextEditingController();
  final mobileController = TextEditingController();
  final vehicleController = TextEditingController();
  final companyController = TextEditingController();
  final purposeController = TextEditingController();
  late final TextEditingController societyController;

  String selectedType = 'Guest';
  String selectedResident = 'Unlinked / Walk-in';

  DateTime? expectedAt;
  DateTime? validUntil;

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
        borderSide: const BorderSide(color: visitorPrimary),
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
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, required: required),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: TextCapitalization.words,
          decoration: _decoration(hint),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $title';
                  }

                  if (title == 'Mobile Number' &&
                      !RegExp(r'^[0-9]{10}$')
                          .hasMatch(value.trim())) {
                    return 'Enter valid 10 digit number';
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
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

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'dd/mm/yyyy, --:-- --';
    }

    final dateText =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    final time = TimeOfDay.fromDateTime(date);

    return '$dateText, ${time.format(context)}';
  }

  Future<DateTime?> _pickDateTime(DateTime? initial) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: visitorPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (date == null) return null;

    if (!mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay.fromDateTime(initial)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: visitorPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Widget _dateField({
    required String title,
    required DateTime? value,
    required Function(DateTime?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title, required: true),
        InkWell(
          onTap: () async {
            final result = await _pickDateTime(value);

            if (!mounted) return;

            if (result != null) {
              onChanged(result);
            }
          },
          child: InputDecorator(
            decoration: _decoration(''),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(value),
                    style: TextStyle(
                      fontSize: 12,
                      color: value == null ? hintColor : textColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _formContent(bool isWide) {
    final fields = <Widget>[
      _field(
        title: 'Society',
        hint: widget.societyName,
        controller: societyController,
        readOnly: true,
      ),
      _field(
        title: 'Visitor Name',
        hint: 'Visitor name',
        controller: visitorNameController,
        required: true,
      ),
      _field(
        title: 'Mobile Number',
        hint: '10 digit mobile number',
        controller: mobileController,
        required: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
      ),
      _dropdown(
        title: 'Type',
        value: selectedType,
        items: ['Guest', 'Delivery', 'Cab', 'Maid'],
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedType = value);
          }
        },
      ),
      _dropdown(
        title: 'Resident',
        value: selectedResident,
        items: ['Unlinked / Walk-in'],
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedResident = value);
          }
        },
      ),
      _field(
        title: 'Vehicle Number',
        hint: 'MH12AB1234',
        controller: vehicleController,
      ),
      _field(
        title: 'Company / Service',
        hint: 'Courier, cab, vendor',
        controller: companyController,
      ),
      _dateField(
        title: 'Expected At',
        value: expectedAt,
        onChanged: (value) {
          setState(() => expectedAt = value);
        },
      ),
      _dateField(
        title: 'Valid Until',
        value: validUntil,
        onChanged: (value) {
          setState(() => validUntil = value);
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children: fields.map((field) {
            return SizedBox(
              width: isWide
                  ? (MediaQuery.of(context).size.width - 76) / 2
                  : double.infinity,
              child: field,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _label('Purpose'),
        TextFormField(
          controller: purposeController,
          maxLines: 3,
          decoration: _decoration('Reason for visit'),
        ),
      ],
    );
  }

  void _submit() {
    // Validate text fields
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Validate Expected At
    if (expectedAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Expected At date and time'),
        ),
      );
      return;
    }

    // Validate Valid Until
    if (validUntil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Valid Until date and time'),
        ),
      );
      return;
    }

    // Validate date range
    if (validUntil!.isBefore(expectedAt!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valid Until must be after Expected At'),
        ),
      );
      return;
    }

    // Create visitor pass
    final visitor = VisitorPassModel(
      society: widget.societyName,
      visitorName: visitorNameController.text.trim(),
      mobileNumber: mobileController.text.trim(),
      type: selectedType,
      resident: selectedResident,
      vehicleNumber: vehicleController.text.trim(),
      companyService: companyController.text.trim(),
      expectedAt: expectedAt!,
      validUntil: validUntil!,
      purpose: purposeController.text.trim(),
    );

    Navigator.pop(context, visitor);
  }

  @override
  void dispose() {
    visitorNameController.dispose();
    mobileController.dispose();
    vehicleController.dispose();
    companyController.dispose();
    purposeController.dispose();
    societyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isWide = MediaQuery.of(context).size.width > 600;

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
                        'New Visitor Pass',
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

              // Form content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VISITOR INFORMATION',
                          style: TextStyle(
                            fontSize: 11,
                            color: visitorPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: borderColor),
                        const SizedBox(height: 14),
                        _formContent(isWide),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer buttons
              Container(
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
                        backgroundColor: visitorPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(110, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text('Create Pass'),
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

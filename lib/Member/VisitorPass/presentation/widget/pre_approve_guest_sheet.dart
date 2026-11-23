
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

class VisitorPassFormModel {
  final String visitorName;
  final String phone;
  final String type;
  final DateTime expectedAt;
  final String vehicleNumber;
  final String company;
  final String purpose;

  const VisitorPassFormModel({
    required this.visitorName,
    required this.phone,
    required this.type,
    required this.expectedAt,
    required this.vehicleNumber,
    required this.company,
    required this.purpose,
  });
}

Future<VisitorPassFormModel?> showPreApproveGuestBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet<VisitorPassFormModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PreApproveGuestBottomSheet(),
  );
}

class _PreApproveGuestBottomSheet extends StatefulWidget {
  const _PreApproveGuestBottomSheet();

  @override
  State<_PreApproveGuestBottomSheet> createState() =>
      _PreApproveGuestBottomSheetState();
}

class _PreApproveGuestBottomSheetState
    extends State<_PreApproveGuestBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _companyController = TextEditingController();
  final _purposeController = TextEditingController();

  String _visitorType = 'Guest';
  DateTime? _expectedAt;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleController.dispose();
    _companyController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Widget _visitorField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF44516A),
            ),
            if (label.contains('*'))
              const CommonText(
                text: '',
                fontSize: 12,
                color: _primaryColor,
              ),
          ],
        ),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          maxLength: maxLength,
        
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _selectExpectedAt() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _expectedAt ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null || !mounted) return;

    setState(() {
      _expectedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day}/${date.month}/${date.year}, '
        '$hour:$minute $period';
  }

  void _savePass() {
    if (!_formKey.currentState!.validate()) return;

    if (_expectedAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select expected date and time'),
        ),
      );
      return;
    }

    final pass = VisitorPassFormModel(
      visitorName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      type: _visitorType,
      expectedAt: _expectedAt!,
      vehicleNumber: _vehicleController.text.trim(),
      company: _companyController.text.trim(),
      purpose: _purposeController.text.trim(),
    );

    Navigator.pop(context, pass);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                20, 20, 12, 18,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE7F0),
                    Color(0xFFFFEBD9),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: 'Pre-Approve a Guest',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                        SizedBox(height: 5),
                        CommonText(
                          text: 'Create an OTP pass for your expected visitor',
                          fontSize: 11,
                          color: _hintColor,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _visitorField(
                        label: 'Visitor Name *',
                        hint: 'Full name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter visitor name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      _visitorField(
                        label: 'Phone *',
                        hint: '10 digit number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[0-9]{10}$')
                                  .hasMatch(value.trim())) {
                            return 'Enter valid 10 digit number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Visitor type
                      const CommonText(
                        text: 'Type *',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF44516A),
                      ),

                      const SizedBox(height: 7),

                      DropdownButtonFormField<String>(
                        value: _visitorType,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                              color: Color(0xFFDCE3EF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                              color: Color(0xFFDCE3EF),
                            ),
                          ),
                        ),
                        items: const [
                          'Guest',
                          'Delivery',
                          'Service',
                          'Cab',
                          'Other',
                        ].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _visitorType = value);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Expected date
                      const CommonText(
                        text: 'Expected At *',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF44516A),
                      ),

                      const SizedBox(height: 7),

                      InkWell(
                        onTap: _selectExpectedAt,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            hintText: 'Select date and time',
                            suffixIcon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 19,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                color: Color(0xFFDCE3EF),
                              ),
                            ),
                          ),
                          child: Text(
                            _expectedAt == null
                                ? 'Select date and time'
                                : _formatDate(_expectedAt!),
                            style: TextStyle(
                              fontSize: 13,
                              color: _expectedAt == null
                                  ? _hintColor
                                  : _textColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _visitorField(
                        label: 'Vehicle No.',
                        hint: 'Optional',
                        controller: _vehicleController,
                      ),

                      const SizedBox(height: 16),

                      _visitorField(
                        label: 'Company',
                        hint: 'Optional',
                        controller: _companyController,
                      ),

                      const SizedBox(height: 16),

                      _visitorField(
                        label: 'Purpose *',
                        hint: 'Reason for visit',
                        controller: _purposeController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter purpose';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      CommonButton(
                        text: 'Create Pass',
                        icon: Icons.check_rounded,
                        onPressed: _savePass,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

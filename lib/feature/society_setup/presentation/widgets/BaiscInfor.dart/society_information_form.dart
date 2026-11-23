
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

class SocietyInformationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController societyNameController;
  final TextEditingController addressController;
  final TextEditingController pincodeController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController registrationController;
  final TextEditingController panController;

  const SocietyInformationForm({
    super.key,
    required this.formKey,
    required this.societyNameController,
    required this.addressController,
    required this.pincodeController,
    required this.cityController,
    required this.stateController,
    required this.registrationController,
    required this.panController,
  });

  static const Color primaryColor = Color(0xFFE93691);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: 12,
              color: const Color(0xFF44516A),
              fontWeight: FontWeight.w600,
            ),
            const CommonText(
              text: ' *',
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 9),
                const CommonText(
                  text: 'Basic Details',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ],
            ),
            const SizedBox(height: 22),

            _field(
              label: 'Society Name',
              hint: 'Enter society name',
              controller: societyNameController,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter society name'
                      : null,
            ),
            const SizedBox(height: 17),

            _field(
              label: 'Address',
              hint: 'Enter society address',
              controller: addressController,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter address'
                      : null,
            ),
            const SizedBox(height: 17),

            _field(
              label: 'Pincode',
              hint: 'Enter 6-digit pincode',
              controller: pincodeController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter pincode';
                }

                if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                  return 'Enter valid 6-digit pincode';
                }

                return null;
              },
            ),
            const SizedBox(height: 17),

            _field(
              label: 'City',
              hint: 'Enter city',
              controller: cityController,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter city'
                      : null,
            ),
            const SizedBox(height: 17),

            _field(
              label: 'State',
              hint: 'Enter state',
              controller: stateController,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter state'
                      : null,
            ),
            const SizedBox(height: 17),

            _field(
              label: 'Registration Number',
              hint: 'Enter registration number',
              controller: registrationController,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Please enter registration number'
                      : null,
            ),
            const SizedBox(height: 17),

            _field(
              label: 'PAN Number',
              hint: 'e.g. ABCDE1234F',
              controller: panController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter PAN number';
                }

                if (!RegExp(
                  r'^[A-Z]{5}[0-9]{4}[A-Z]$',
                ).hasMatch(value.trim().toUpperCase())) {
                  return 'Enter a valid PAN number';
                }

                return null;
              },
            ),
            const SizedBox(height: 5),

            const CommonText(
              text: 'Format: 5 letters + 4 digits + 1 letter',
              fontSize: 11,
              color: hintColor,
            ),
          ],
        ),
      ),
    );
  }
}

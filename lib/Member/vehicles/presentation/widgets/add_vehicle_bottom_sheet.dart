
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

import '../../domain/vehicle_model.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<VehicleModel?> showAddVehicleBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet<VehicleModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddVehicleBottomSheet(),
  );
}

class _AddVehicleBottomSheet extends StatefulWidget {
  const _AddVehicleBottomSheet();

  @override
  State<_AddVehicleBottomSheet> createState() =>
      _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState
    extends State<_AddVehicleBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _licensePlateController = TextEditingController();
  final _makeModelController = TextEditingController();

  String _vehicleType = '4-Wheeler (Car)';

  final List<String> _vehicleTypes = [
    '4-Wheeler (Car)',
    '2-Wheeler (Bike)',
    '3-Wheeler',
    'Other',
  ];

  @override
  void dispose() {
    _licensePlateController.dispose();
    _makeModelController.dispose();
    super.dispose();
  }

  Widget _vehicleField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
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
            const CommonText(
              text: ' *',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          textInputAction: TextInputAction.next,
        
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
        ),
      ],
    );
  }

  Widget _vehicleTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            CommonText(
              text: 'Vehicle Type',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF44516A),
            ),
            CommonText(
              text: ' *',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 7),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFDCE3EE),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _vehicleType,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _hintColor,
              ),
              style: const TextStyle(
                color: _textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: _vehicleTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _vehicleType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = VehicleModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      vehicleType: _vehicleType,
      licensePlate:
          _licensePlateController.text.trim().toUpperCase(),
      makeAndModel: _makeModelController.text.trim(),
    );

    Navigator.pop(context, vehicle);
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
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 18),
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
                    child: CommonText(
                      text: 'Register New Vehicle',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
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
                      _vehicleTypeField(),

                      const SizedBox(height: 18),

                      _vehicleField(
                        label: 'License Plate',
                        hint: 'E.g. MH-12-AB-1234',
                        controller: _licensePlateController,
                        textCapitalization:
                            TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter license plate';
                          }

                          if (!RegExp(
                            r'^[A-Z]{2}[- ]?\d{1,2}[- ]?[A-Z]{1,3}[- ]?\d{1,4}$',
                          ).hasMatch(value.trim().toUpperCase())) {
                            return 'Enter a valid registration number';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      _vehicleField(
                        label: 'Make & Model',
                        hint: 'E.g. Honda City',
                        controller: _makeModelController,
                      ),

                      const SizedBox(height: 25),

                      CommonButton(
                        text: 'Register Vehicle',
                        icon: Icons.check_rounded,
                        onPressed: _saveVehicle,
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

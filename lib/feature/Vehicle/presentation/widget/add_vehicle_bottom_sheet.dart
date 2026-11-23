
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/Vehicle/presentation/bloc/VehicleModel.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);

Future<VehicleModel?> showAddVehicleBottomSheet(
  BuildContext context, {
  required List<String> members,
  required List<String> parkingSlots,
}) {
  return showModalBottomSheet<VehicleModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddVehicleBottomSheet(
      members: members,
      parkingSlots: parkingSlots,
    ),
  );
}

class _AddVehicleBottomSheet extends StatefulWidget {
  final List<String> members;
  final List<String> parkingSlots;

  const _AddVehicleBottomSheet({
    required this.members,
    required this.parkingSlots,
  });

  @override
  State<_AddVehicleBottomSheet> createState() =>
      _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState
    extends State<_AddVehicleBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _licenseController = TextEditingController();
  final _makeModelController = TextEditingController();

  String? _selectedMember;
  String? _selectedParkingSlot;
  String _vehicleType = '4-Wheeler';

  @override
  void dispose() {
    _licenseController.dispose();
    _makeModelController.dispose();
    super.dispose();
  }

  Widget _label(String title, {bool required = false}) {
    return Row(
      children: [
        CommonText(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF44516A),
        ),
        if (required)
          const CommonText(
            text: ' *',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _primaryColor,
          ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF91A0B8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: _primaryColor,
              ),
            ),
          ),
          items: items.toSet().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: required
              ? (value) =>
                  value == null ? 'Please select $label' : null
              : null,
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          textInputAction: TextInputAction.next,
         
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = VehicleModel(
      memberName: _selectedMember!,
      parkingSlot: _selectedParkingSlot ?? '',
      licensePlate: _licenseController.text.trim().toUpperCase(),
      makeModel: _makeModelController.text.trim(),
      vehicleType: _vehicleType,
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
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
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
                      text: 'Register Vehicle',
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

            // FORM
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dropdown(
                        label: 'Member Name',
                        hint: '-- Select Member --',
                        items: widget.members,
                        value: _selectedMember,
                        required: true,
                        onChanged: (value) {
                          setState(() => _selectedMember = value);
                        },
                      ),
                      const SizedBox(height: 18),

                      _dropdown(
                        label: 'Assign to Parking Slot (Optional)',
                        hint: '-- No Assigned Slot --',
                        items: widget.parkingSlots,
                        value: _selectedParkingSlot,
                        onChanged: (value) {
                          setState(() => _selectedParkingSlot = value);
                        },
                      ),
                      const SizedBox(height: 18),

                      _textField(
                        label: 'License Plate',
                        hint: 'E.G. MH-12-AB-1234',
                        controller: _licenseController,
                        required: true,
                      ),
                      const SizedBox(height: 18),

                      _textField(
                        label: 'Make / Model',
                        hint: 'e.g. Honda City',
                        controller: _makeModelController,
                      ),
                      const SizedBox(height: 18),

                      _dropdown(
                        label: 'Vehicle Type',
                        hint: 'Select Vehicle Type',
                        items: const [
                          '2-Wheeler',
                          '4-Wheeler',
                        ],
                        value: _vehicleType,
                        required: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _vehicleType = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // FOOTER
          
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 14,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border(
      top: BorderSide(
        color: Colors.grey.shade200,
      ),
    ),
  ),
  child: Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: _textColor,
              side: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: SizedBox(
          height: 44,
          child: Expanded(
            child: CommonButton(
              text: 'Save Vehicle',
              onPressed: _saveVehicle,
            ),
          ),
        ),
      ),
    ],
  ),
)

          ],
        ),
      ),
    );
  }
}

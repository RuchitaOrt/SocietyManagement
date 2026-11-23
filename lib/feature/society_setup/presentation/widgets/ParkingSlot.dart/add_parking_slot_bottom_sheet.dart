
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/ParkingSlotModel.dart';



const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<ParkingSlotModel?> showAddParkingSlotBottomSheet(
  BuildContext context, {
  required List<String> wings,
  required Map<String, List<String>> flatsByWing,
  String? initialWing,
}) {
  return showModalBottomSheet<ParkingSlotModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => AddParkingSlotBottomSheet(
      wings: wings,
      flatsByWing: flatsByWing,
      initialWing: initialWing,
    ),
  );
}

class AddParkingSlotBottomSheet extends StatefulWidget {
  final List<String> wings;
  final Map<String, List<String>> flatsByWing;
  final String? initialWing;

  const AddParkingSlotBottomSheet({
    super.key,
    required this.wings,
    required this.flatsByWing,
    this.initialWing,
  });

  @override
  State<AddParkingSlotBottomSheet> createState() =>
      _AddParkingSlotBottomSheetState();
}

class _AddParkingSlotBottomSheetState
    extends State<AddParkingSlotBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _slotNumberController = TextEditingController();

  String? _selectedWing;
  String? _selectedFlat;
  String? _selectedSlotType = '2-Wheeler';

  final List<String> _slotTypes = [
    '2-Wheeler',
    '4-Wheeler',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.wings.contains(widget.initialWing)) {
      _selectedWing = widget.initialWing;
    } else if (widget.wings.isNotEmpty) {
      _selectedWing = widget.wings.first;
    }
  }

  @override
  void dispose() {
    _slotNumberController.dispose();
    super.dispose();
  }

  List<String> get _availableFlats {
    return widget.flatsByWing[_selectedWing] ?? [];
  }

  // Common Dropdown Field
  Widget _dropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = true,
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
            if (isRequired)
              const CommonText(
                text: ' *',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
          ],
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              color: _hintColor,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: _hintColor,
            size: 20,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFFDCE3EF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: _primaryColor,
              ),
            ),
            errorStyle: const TextStyle(fontSize: 10),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textColor,
                ),
              ),
            );
          }).toList(),
          onChanged: items.isEmpty ? null : onChanged,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Slot Number Field
  Widget _slotNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            CommonText(
              text: 'Slot Number',
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
        CommonTextField(
          controller: _slotNumberController,
          hintText: 'e.g. B1-45',
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter slot number';
            }

            if (!RegExp(r'^[a-zA-Z0-9-]+$')
                .hasMatch(value.trim())) {
              return 'Enter a valid slot number';
            }

            return null;
          },
        ),
      ],
    );
  }

  // Save Slot
  void _saveSlot() {
    if (!_formKey.currentState!.validate()) return;

    final slot = ParkingSlotModel(
      wing: _selectedWing!,
      flatNumber: _selectedFlat!,
      slotNumber: _slotNumberController.text.trim(),
      slotType: _selectedSlotType!,
    );

    Navigator.pop(context, slot);
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
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: CommonText(
                      text: 'Add Parking Slot',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: _hintColor,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    18, 18, 18, 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wing
                      _dropdownField(
                        label: 'Wing',
                        hint: 'Select Wing',
                        value: _selectedWing,
                        items: widget.wings,
                        onChanged: (value) {
                          setState(() {
                            _selectedWing = value;
                            _selectedFlat = null;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      // Flat Number
                      _dropdownField(
                        label: 'Flat No',
                        hint: _availableFlats.isEmpty
                            ? 'No flats available'
                            : '-- Select Flat --',
                        value: _selectedFlat,
                        items: _availableFlats,
                        onChanged: (value) {
                          setState(() {
                            _selectedFlat = value;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      // Slot Number
                      _slotNumberField(),

                      const SizedBox(height: 18),

                      // Slot Type
                      _dropdownField(
                        label: 'Slot Type',
                        hint: 'Select Slot Type',
                        value: _selectedSlotType,
                        items: _slotTypes,
                        onChanged: (value) {
                          setState(() {
                            _selectedSlotType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(
                18, 12, 18, 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textColor,
                      side: const BorderSide(
                        color: Color(0xFFDCE3EF),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveSlot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                    ),
                    child: const Text(
                      'Save Slot',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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


import 'package:flutter/material.dart';

import '../../bloc/HeadModel.dart';

const Color primaryColor = Color(0xFFE93691);

Future<HeadModel?> showAddHeadBottomSheet({
  required BuildContext context,
  List<String> accountGroups = const [],
  List<String> ledgers = const [],
  List<String> areas = const [],
}) {
  return showModalBottomSheet<HeadModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AddHeadBottomSheet(
        accountGroups: accountGroups,
        ledgers: ledgers,
        areas: areas,
      );
    },
  );
}

class AddHeadBottomSheet extends StatefulWidget {
  final List<String> accountGroups;
  final List<String> ledgers;
  final List<String> areas;

  const AddHeadBottomSheet({
    super.key,
    this.accountGroups = const [],
    this.ledgers = const [],
    this.areas = const [],
  });

  @override
  State<AddHeadBottomSheet> createState() =>
      _AddHeadBottomSheetState();
}

class _AddHeadBottomSheetState
    extends State<AddHeadBottomSheet> {

  final _formKey = GlobalKey<FormState>();

  final headNameController = TextEditingController();
  final chargeRateController = TextEditingController();

  bool isAreaWise = false;

  String? selectedAccountGroup;
  String? selectedLedger;

  String selectedChargeType =
      'Fixed (Apply directly to all flats)';

  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);
  static const Color borderColor = Color(0xFFDCE4EF);
final List<AreaChargeRow> areaChargeRows = [
  AreaChargeRow(),
  AreaChargeRow(),
];
void _addAreaRow() {
  setState(() {
    areaChargeRows.add(AreaChargeRow());
  });
}

void _removeAreaRow(int index) {
  if (areaChargeRows.length <= 1) return;

  setState(() {
    areaChargeRows[index].dispose();
    areaChargeRows.removeAt(index);
  });
}

Widget _areaChargeSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE8F1),
              Color(0xFFFFEFDC),
            ],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
       child: Row(
  children: [
    const Expanded(
      child: Text(
        'AREA (SQ.FT)',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    ),
    const Expanded(
      child: Text(
        'CHARGES (₹)',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    ),
    SizedBox(
      width: 30,
      height: 28,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: _addAreaRow,
        icon: const Icon(
          Icons.add,
          size: 19,
        ),
        style: IconButton.styleFrom(
          foregroundColor: Colors.green,
          backgroundColor: const Color(0xFFD1FAE5),
          side: const BorderSide(
            color: Color(0xFF6EE7B7),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    ),
  ],
),
      ),

      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: borderColor),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        child: Column(
          children: List.generate(
            areaChargeRows.length,
            (index) {
              final row = areaChargeRows[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField<String>(
                        value: row.selectedArea,
                        isExpanded: true,
                        hint: const Text(
                          'Select Area',
                          style: TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: hintColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 11,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                        ),
                        items: widget.areas.map((area) {
                          return DropdownMenuItem<String>(
                            value: area,
                            child: Text(
                              area,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (isAreaWise && value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            row.selectedArea = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: row.chargeController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (!isAreaWise) return null;

                          final charge = double.tryParse(
                            value?.trim() ?? '',
                          );

                          if (charge == null || charge < 0) {
                            return 'Enter valid amount';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: hintColor,
                          ),
                          prefixText: 'Rs. ',
                          prefixStyle: const TextStyle(
                            fontSize: 11,
                            color: hintColor,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 11,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 28,
                      height: 44,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: areaChargeRows.length > 1
                            ? () => _removeAreaRow(index)
                            : null,
                        icon: const Icon(
                          Icons.remove,
                          size: 19,
                        ),
                        style: IconButton.styleFrom(
                          foregroundColor: hintColor,
                          side: const BorderSide(
                            color: borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                   
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (required &&
                (value == null || value.trim().isEmpty)) {
              return 'Please enter $label';
            }

            if (label == 'Charge / Rate' &&
                value != null &&
                value.trim().isNotEmpty) {
              final rate = double.tryParse(value.trim());

              if (rate == null || rate < 0) {
                return 'Enter a valid charge rate';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFFBCC9DA),
            ),
            prefixText: label == 'Charge / Rate' ? 'Rs.  ' : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
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
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 7),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primaryColor,
          ),
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF202B43),
            ),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
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
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: items.isEmpty ? null : onChanged,
        ),
      ],
    );
  }

  Widget _areaWiseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Area-wise', required: true),
        const SizedBox(height: 7),

        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              _areaOption('Yes', true),
              _areaOption('No', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _areaOption(String title, bool value) {
    final selected = isAreaWise == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isAreaWise = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF52647D)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

void _submit() {
  if (!(_formKey.currentState?.validate() ?? false)) {
    return;
  }

  List<AreaChargeModel> charges = [];

  if (isAreaWise) {
    final selectedAreas = areaChargeRows
        .map((row) => row.selectedArea)
        .toList();

    if (selectedAreas.toSet().length != selectedAreas.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select different areas.'),
        ),
      );
      return;
    }

    charges = areaChargeRows.map((row) {
      return AreaChargeModel(
        area: row.selectedArea!,
        charge: double.parse(
          row.chargeController.text.trim(),
        ),
      );
    }).toList();
  }

  final rate = isAreaWise
      ? 0.0
      : double.tryParse(chargeRateController.text.trim());

  if (rate == null) return;

  Navigator.pop(
    context,
    HeadModel(
      headName: headNameController.text.trim(),
      isAreaWise: isAreaWise,
      accountGroup: selectedAccountGroup,
      linkedLedger: selectedLedger,
      chargeType: selectedChargeType,
      chargeRate: rate,
      areaCharges: charges,
    ),
  );
}
@override
void dispose() {
  headNameController.dispose();
  chargeRateController.dispose();

  for (final row in areaChargeRows) {
    row.dispose();
  }

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
        height: screenHeight * 0.82,
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
                vertical: 17,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Head',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Single charge for all areas',
                          style: TextStyle(
                            fontSize: 12,
                            color: hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),

            // FORM
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // HEAD NAME + AREA WISE
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _textField(
                              label: 'Head Name',
                              controller: headNameController,
                              hint: 'e.g., Club House Fee',
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _areaWiseSelector(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ACCOUNT GROUP + LEDGER
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _dropdown(
                              label: 'Account Group (Optional)',
                              hint: '-- Select Account Group --',
                              value: selectedAccountGroup,
                              items: widget.accountGroups,
                              onChanged: (value) {
                                setState(() {
                                  selectedAccountGroup = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dropdown(
                              label: 'Linked Ledger (Optional)',
                              hint: '-- Select Ledger --',
                              value: selectedLedger,
                              items: widget.ledgers,
                              onChanged: (value) {
                                setState(() {
                                  selectedLedger = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                     


if (isAreaWise) ...[
  _areaChargeSection(),
] else ...[
  _dropdown(
    label: 'Charge Type',
    hint: 'Select Charge Type',
    value: selectedChargeType,
    items: const [
      'Fixed (Apply directly to all flats)',
    ],
    onChanged: (value) {
      if (value != null) {
        setState(() {
          selectedChargeType = value;
        });
      }
    },
  ),

  const SizedBox(height: 16),

  _textField(
    label: 'Charge / Rate',
    controller: chargeRateController,
    hint: '0',
    required: true,
    keyboardType:
        const TextInputType.numberWithOptions(
      decimal: true,
    ),
  ),
],
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
                        side: const BorderSide(
                          color: borderColor,
                        ),
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
                        'Add Head',
                        maxLines: 1,
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
class AreaChargeRow {
  String? selectedArea;
  final TextEditingController chargeController =
      TextEditingController();

  void dispose() {
    chargeController.dispose();
  }
}
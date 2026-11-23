
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

// Open bottom sheet and return generated flats.
Future<List<FlatModel>?> showAddFlatRangeBottomSheet({
  required BuildContext context,
  required List<String> wings,
}) {
  if (wings.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please add wings first'),
      ),
    );
    return Future.value(null);
  }

  return showModalBottomSheet<List<FlatModel>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddFlatRangeBottomSheet(wings: wings),
  );
}

class AddFlatRangeBottomSheet extends StatefulWidget {
  final List<String> wings;

  const AddFlatRangeBottomSheet({
    super.key,
    required this.wings,
  });

  @override
  State<AddFlatRangeBottomSheet> createState() =>
      _AddFlatRangeBottomSheetState();
}

class _AddFlatRangeBottomSheetState
    extends State<AddFlatRangeBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedWing;
  String _selectedFlatType = 'Residential';

  bool _areaDiffersByPosition = true;

  final _startingFlatController =
      TextEditingController(text: '101');

  final _flatsPerFloorController =
      TextEditingController(text: '3');

  final _totalFloorsController =
      TextEditingController(text: '4');

  final _commonAreaController = TextEditingController();

  final List<TextEditingController> _areaControllers =
      List.generate(100, (_) => TextEditingController());

  int get _startingNumber =>
      int.tryParse(_startingFlatController.text.trim()) ?? 0;

  int get _flatsPerFloor =>
      int.tryParse(_flatsPerFloorController.text.trim()) ?? 0;

  int get _totalFloors =>
      int.tryParse(_totalFloorsController.text.trim()) ?? 0;

  int get _totalFlats => _flatsPerFloor * _totalFloors;

  @override
  void initState() {
    super.initState();
    _selectedWing = widget.wings.first;
  }

  @override
  void dispose() {
    _startingFlatController.dispose();
    _flatsPerFloorController.dispose();
    _totalFloorsController.dispose();
    _commonAreaController.dispose();

    for (final controller in _areaControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Original flat-number formula:
  // 101, 102, 103
  // 201, 202, 203
  // 301, 302, 303
  List<Map<String, dynamic>> _generatePreview() {
    final result = <Map<String, dynamic>>[];

    if (_startingNumber <= 0 ||
        _flatsPerFloor <= 0 ||
        _totalFloors <= 0 ||
        _totalFlats > 1000) {
      return result;
    }

    final base = (_startingNumber ~/ 100) * 100;
    final startPosition = _startingNumber % 100;

    for (int floor = 0; floor < _totalFloors; floor++) {
      final numbers = <String>[];

      for (int position = 0;
          position < _flatsPerFloor;
          position++) {
        final number =
            base + (floor * 100) + startPosition + position;

        numbers.add(number.toString());
      }

      result.add({
        'floor': floor + 1,
        'numbers': numbers,
      });
    }

    return result;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedWing == null) return;

    if (_flatsPerFloor < 1 ||
        _flatsPerFloor > 100 ||
        _totalFloors < 1 ||
        _totalFloors > 100 ||
        _totalFlats > 1000 ||
        _startingNumber <= 0) {
      _showMessage('Please enter valid flat range details');
      return;
    }

    // Validate area by position.
    if (_areaDiffersByPosition) {
      for (int i = 0; i < _flatsPerFloor; i++) {
        final value = double.tryParse(
          _areaControllers[i].text.trim(),
        );

        if (value == null || value <= 0) {
          _showMessage(
            'Enter valid area for position ${i + 1}',
          );
          return;
        }
      }
    } else {
      final value = double.tryParse(
        _commonAreaController.text.trim(),
      );

      if (value == null || value <= 0) {
        _showMessage('Enter a valid common area');
        return;
      }
    }

    final generated = <FlatModel>[];

    final base = (_startingNumber ~/ 100) * 100;
    final startPosition = _startingNumber % 100;

    for (int floor = 0; floor < _totalFloors; floor++) {
      for (int position = 0;
          position < _flatsPerFloor;
          position++) {
        final flatNumber =
            base + (floor * 100) + startPosition + position;

        // Same position area is reused on every floor.
        final area = _areaDiffersByPosition
            ? double.parse(
                _areaControllers[position].text.trim(),
              )
            : double.parse(
                _commonAreaController.text.trim(),
              );

        generated.add(
          FlatModel(
            wing: _selectedWing!,
            flatType: _selectedFlatType,
            floor: floor + 1,
            flatNumber: flatNumber.toString(),
            position: position + 1,
            area: area,
          ),
        );
      }
    }

    if (generated.isNotEmpty) {
      Navigator.pop(context, generated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _generatePreview();

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
            _header(),

            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wing and Flat Type
                      Row(
                        children: [
                          Expanded(
                            child: _flatDropdown(
                              label: 'Wing',
                              value: _selectedWing!,
                              items: widget.wings,
                              onChanged: (value) {
                                setState(() {
                                  _selectedWing = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _flatDropdown(
                              label: 'Flat Type',
                              value: _selectedFlatType,
                              items: const [
                                'Residential',
                                'Commercial',
                                'Parking',
                                'Other',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedFlatType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Flat range fields
                      Row(
                        children: [
                          Expanded(
                            child: _flatInput(
                              label: 'Starting Flat No.',
                              controller: _startingFlatController,
                              onChanged: () => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _flatInput(
                              label: 'Flats per Floor',
                              controller: _flatsPerFloorController,
                              onChanged: () => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _flatInput(
                              label: 'Total Floors',
                              controller: _totalFloorsController,
                              onChanged: () => setState(() {}),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: CommonText(
                          text: 'Total floors to create (max 100)',
                          fontSize: 10,
                          color: _hintColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Original floor-wise preview
                      _previewSection(preview),

                      const SizedBox(height: 16),

                      const CommonText(
                        text: 'Area (sq.ft)',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textColor,
                      ),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: _primaryColor,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        title: const CommonText(
                          text: 'Area differs by flat position',
                          fontSize: 11,
                          color: _textColor,
                        ),
                        value: _areaDiffersByPosition,
                        onChanged: (value) {
                          setState(() {
                            _areaDiffersByPosition = value ?? false;
                          });
                        },
                      ),

                      // Original pink area panel
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF7C9DF),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(
                              text: 'AREA BY FLAT POSITION',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _hintColor,
                            ),

                            const SizedBox(height: 12),

                            if (_areaDiffersByPosition)
                              _buildIndividualAreaFields()
                            else
                           CommonTextField(
  controller: _commonAreaController,
  hintText: 'Enter area in sq.ft',
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  validator: (value) {
    final area = double.tryParse(value?.trim() ?? '');

    if (area == null || area <= 0) {
      return 'Enter valid area';
    }

    return null;
  },
),

                            const SizedBox(height: 8),

                            const CommonText(
                              text:
                                  'Position 01 applies to 101, 201, 301...',
                              fontSize: 9,
                              color: _hintColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      CommonButton(
                        text: 'Generate Flats',
                        icon: Icons.check_rounded,
                        onPressed: _submit,
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

  Widget _header() {
    return Container(
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
              text: 'Add New Flats',
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
    );
  }

Widget _flatInput({
  required String label,
  required TextEditingController controller,
  VoidCallback? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF44516A),
        ),
      ),
      const SizedBox(height: 7),
      CommonTextField(
        controller: controller,
        hintText: label,
        keyboardType: TextInputType.number,
        validator: (value) {
          final number = int.tryParse(value?.trim() ?? '');

          if (number == null || number <= 0) {
            return 'Invalid';
          }

          return null;
        },
      ),
    ],
  );
}

  Widget _flatDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF44516A),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _previewSection(List<Map<String, dynamic>> preview) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF7C9DF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$_totalFlats',
                  style: const TextStyle(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      ' flats will be created across $_totalFloors floors with $_flatsPerFloor flats per floor',
                  style: const TextStyle(
                    color: _hintColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ...preview.map((floorData) {
            final numbers = floorData['numbers'] as List<String>;

            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Wrap(
                spacing: 6,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFE3E8F0),
                      ),
                    ),
                    child: CommonText(
                      text: 'Floor ${floorData['floor']}',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: _hintColor,
                  ),
                  ...numbers.map((number) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8F1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFFF7C9DF),
                        ),
                      ),
                      child: CommonText(
                        text: number,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Important: one area field per position, not per flat.
  Widget _buildIndividualAreaFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 3;

        return Wrap(
          spacing: 8,
          runSpacing: 12,
          children: List.generate(
            _flatsPerFloor.clamp(0, 100),
            (index) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: (index + 1)
                          .toString()
                          .padLeft(2, '0'),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                    const SizedBox(height: 6),
                   CommonTextField(
  controller: _areaControllers[index],
  hintText: 'sq.ft',
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  validator: (value) {
    final area = double.tryParse(value?.trim() ?? '');

    if (area == null || area <= 0) {
      return 'Invalid area';
    }

    return null;
  },
),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

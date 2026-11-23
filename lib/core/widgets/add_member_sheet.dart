
import 'package:flutter/material.dart';

import 'package:society_management/core/constants/AppTextSizes.dart';
import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';
import 'package:society_management/feature/auth/presentation/bloc/member_setup_model.dart';


const Color primaryColor = Color(0xFFE93691);
const Color textColor = Color(0xFF202B43);
const Color hintColor = Color(0xFF91A0B8);

Future<MemberSetupModel?> showAddMemberSheet({
  required BuildContext context,
  required String societyName,
  required List<FlatModel> flats,
}) {
  return showModalBottomSheet<MemberSetupModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddMemberSheet(
      societyName: societyName,
      flats: flats,
    ),
  );
}

class AddMemberSheet extends StatefulWidget {
  final String societyName;
  final List<FlatModel> flats;

  const AddMemberSheet({
    super.key,
    required this.societyName,
    required this.flats,
  });

  @override
  State<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<AddMemberSheet> {
  final _formKey = GlobalKey<FormState>();

  final _ownerController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _dobController = TextEditingController();
  final _panController = TextEditingController();
  final _aadhaarController = TextEditingController();

  final List<TextEditingController> _nominees = [];
  final List<TextEditingController> _coOwners = [];

  String _designation = 'Owner';
  String? _selectedWing;
  String? _selectedFlat;

  List<String> get wings =>
      widget.flats.map((e) => e.wing).toSet().toList();

  List<FlatModel> get filteredFlats {
    if (_selectedWing == null) return [];
    return widget.flats
        .where((e) => e.wing == _selectedWing)
        .toList();
  }

  String get flatAddress {
    if (_selectedFlat == null || _selectedWing == null) {
      return '';
    }
    return 'Wing $_selectedWing - Flat $_selectedFlat';
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _dobController.dispose();
    _panController.dispose();
    _aadhaarController.dispose();

    for (final c in _nominees) {
      c.dispose();
    }
    for (final c in _coOwners) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _sectionTitle(String title, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: title.toUpperCase(),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    bool readOnly = false,
    VoidCallback? onTap,
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
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF44516A),
            ),
            const CommonText(
              text: ' *',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
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

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String hint = 'Select',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF44516A),
            ),
            const CommonText(
              text: ' *',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFCAD3E0),
              fontSize: 12,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
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
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Please select $label' : null,
        ),
      ],
    );
  }

  Widget _addButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 35,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 16),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dynamicPeopleSection({
    required String title,
    required List<TextEditingController> controllers,
    required Color buttonColor,
    required String hint,
  }) {
    return Column(
      children: [
        _sectionTitle(
          title,
          action: _addButton(
            title: 'Add $title',
            color: buttonColor,
            onPressed: () {
              setState(() {
                controllers.add(TextEditingController());
              });
            },
          ),
        ),
        if (controllers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: const Color(0xFFE2EAF3),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline_rounded,
                  color: Color(0xFFB5C2D5),
                  size: 23,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonText(
                    text: 'No ${title.toLowerCase()} added yet.',
                    fontSize: 11,
                    color: hintColor,
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        hintText: hint,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controllers[index].dispose();
                        controllers.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Future<void> _selectDob() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _dobController.text =
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }
  }

  void _saveMember() {
    if (!_formKey.currentState!.validate()) return;

    final member = MemberSetupModel(
      society: widget.societyName,
      designation: _designation,
      ownerName: _ownerController.text.trim(),
      email: _emailController.text.trim(),
      contact: _contactController.text.trim(),
      dob: _dobController.text.trim(),
      panNumber: _panController.text.trim().toUpperCase(),
      aadhaarNumber: _aadhaarController.text.trim(),
      wing: _selectedWing!,
      flatNumber: _selectedFlat!,
      address: flatAddress,
      nominees: _nominees
          .map((e) => e.text.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      coOwners: _coOwners
          .map((e) => e.text.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    Navigator.pop(context, member);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
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
            // Same header design as Add Bank
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
                      text: 'Add Member',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OWNER INFORMATION
                      _sectionTitle('Owner Information'),

                      _field(
                        label: 'Society',
                        hint: widget.societyName,
                        controller: TextEditingController(
                          text: widget.societyName,
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 15),

                      _dropdown(
                        label: 'Designation',
                        value: _designation,
                        items: const [
                          'Owner',
                          'Tenant',
                          'Family Member',
                          'Committee Member',
                        ],
                        onChanged: (value) {
                          setState(() => _designation = value!);
                        },
                      ),
                      const SizedBox(height: 15),

                      _field(
                        label: 'Owner Name',
                        hint: 'Full name',
                        controller: _ownerController,
                      ),
                      const SizedBox(height: 15),

                      _field(
                        label: 'Email',
                        hint: 'email@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _field(
                        label: 'Contact',
                        hint: '10-digit number',
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Enter valid 10-digit contact';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: _selectDob,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dobController,
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Select date of birth'
                                    : null,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth *',
                              hintText: 'dd/mm/yyyy',
                              suffixIcon: const Icon(
                                Icons.calendar_month_rounded,
                                size: 19,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      _field(
                        label: 'PAN Number',
                        hint: 'ABCDE1234F',
                        controller: _panController,
                        maxLength: 10,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                                  .hasMatch(value.toUpperCase())) {
                            return 'Enter valid PAN number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _field(
                        label: 'Aadhaar Number',
                        hint: '12-digit number',
                        controller: _aadhaarController,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[0-9]{12}$').hasMatch(value)) {
                            return 'Enter valid Aadhaar number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFE8EDF4)),
                      const SizedBox(height: 15),

                      // PROPERTY & VEHICLES
                      _sectionTitle('Property & Vehicles'),

                      _dropdown(
                        label: 'Wing',
                        value: _selectedWing,
                        items: wings,
                        hint: 'Select Wing',
                        onChanged: (value) {
                          setState(() {
                            _selectedWing = value;
                            _selectedFlat = null;
                          });
                        },
                      ),
                      const SizedBox(height: 15),

                      _dropdown(
                        label: 'Flats',
                        value: _selectedFlat,
                        items: filteredFlats
                            .map((e) => e.flatNumber)
                            .toList(),
                        hint: _selectedWing == null
                            ? 'Select wing first'
                            : 'Select Flat',
                        onChanged: (value) {
                          setState(() => _selectedFlat = value);
                        },
                      ),
                      const SizedBox(height: 15),

                      const CommonText(
                        text: 'Address',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF44516A),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFDCE3EF),
                          ),
                        ),
                        child: CommonText(
                          text: flatAddress.isEmpty
                              ? 'Auto-filled from flat'
                              : flatAddress,
                          fontSize: 12,
                          color: hintColor,
                        ),
                      ),

                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFE8EDF4)),
                      const SizedBox(height: 15),

                      // NOMINEES
                      _dynamicPeopleSection(
                        title: 'Nominees',
                        controllers: _nominees,
                        buttonColor: const Color(0xFF0DB9AD),
                        hint: 'Enter nominee name',
                      ),

                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFE8EDF4)),
                      const SizedBox(height: 15),

                      // CO-OWNERS
                      _dynamicPeopleSection(
                        title: 'Co-Owners',
                        controllers: _coOwners,
                        buttonColor: const Color(0xFF8745ED),
                        hint: 'Enter co-owner name',
                      ),

                      const SizedBox(height: 24),

                      CommonButton(
                        text: 'Add Member',
                        icon: Icons.person_add_alt_1_rounded,
                        onPressed: _saveMember,
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

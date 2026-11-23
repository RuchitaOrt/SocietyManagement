
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/auth/presentation/bloc/member_setup_model.dart';


const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<MemberSetupModel?> showAddMemberBottomSheet({
  required BuildContext context,
  required String societyName,
  required List<String> flats,
}) {
  return showModalBottomSheet<MemberSetupModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddMemberBottomSheet(
      societyName: societyName,
      flats: flats,
    ),
  );
}

class AddMemberBottomSheet extends StatefulWidget {
  final String societyName;
  final List<String> flats;

  const AddMemberBottomSheet({
    super.key,
    required this.societyName,
    required this.flats,
  });

  @override
  State<AddMemberBottomSheet> createState() =>
      _AddMemberBottomSheetState();
}

class _AddMemberBottomSheetState
    extends State<AddMemberBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // final _nameController = TextEditingController();
  // final _mobileController = TextEditingController();
  // final _emailController = TextEditingController();
final _nameController =
    TextEditingController(text: 'Rahul Sharma');

final _mobileController =
    TextEditingController(text: '9876543210');

final _emailController =
    TextEditingController(text: 'rahul.sharma@gmail.com');
String? _selectedFlat;
String _selectedRole = 'Owner';

@override
void initState() {
  super.initState();

  if (widget.flats.isNotEmpty) {
    _selectedFlat = widget.flats.first;
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedFlat == null) {
    _showMessage('Please select a flat.');
    return;
  }

  final member = MemberSetupModel(
    society: widget.societyName,
    designation: _selectedRole,
    ownerName: _nameController.text.trim(),
    email: _emailController.text.trim(),
    contact: _mobileController.text.trim(),
    dob: '15-05-1985',
    panNumber: 'ABCDE1234F',
    aadhaarNumber: '123456789012',
    wing: _selectedFlat!.split('-').first.trim(),
    flatNumber: _selectedFlat!,
    address: 'Mumbai, Maharashtra',
    nominees: ['Priya Sharma'],
    coOwners: [],
  );

  Navigator.pop(context, member);
}
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7FB),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _sectionTitle('Member Information'),
                      const SizedBox(height: 16),

                      _textField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter member name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),

                      _textField(
                        controller: _mobileController,
                        label: 'Mobile Number',
                        hint: 'Enter mobile number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _textField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'Enter email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 24),
                      _sectionTitle('Flat Assignment'),
                      const SizedBox(height: 16),

                      _dropdown(
                        label: 'Select Flat',
                        value: _selectedFlat,
                        items: widget.flats,
                        hint: 'Choose flat',
                        onChanged: (value) {
                          setState(() => _selectedFlat = value);
                        },
                      ),

                      const SizedBox(height: 16),

                      _dropdown(
                        label: 'Member Type',
                        value: _selectedRole,
                        items: const [
                          'Owner',
                          'Tenant',
                        ],
                        hint: 'Select member type',
                        onChanged: (value) {
                          setState(() => _selectedRole = value!);
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _bottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return  Container(
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
                      text: 'Add New Member',
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _textColor,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _decoration(
            hint: hint,
            icon: icon,
          ),
          validator: (value) {
            final text = value?.trim() ?? '';

            if (text.isEmpty && label != 'Email Address') {
              return 'Please enter $label';
            }

            if (label == 'Mobile Number' &&
                !RegExp(r'^[0-9]{10}$').hasMatch(text)) {
              return 'Enter a valid 10-digit mobile number';
            }

            if (label == 'Email Address' &&
                text.isNotEmpty &&
                !RegExp(
                  r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                ).hasMatch(text)) {
              return 'Enter a valid email address';
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
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: _decoration(hint: hint),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) return 'Please select $label';
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _decoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _hintColor,
        fontSize: 13,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: _hintColor, size: 20)
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE9EDF4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE9EDF4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add Member',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

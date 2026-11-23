
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/FinancialYearModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';


const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<FinancialYearModel?> showAddFinancialYearBottomSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<FinancialYearModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AddFinancialYearBottomSheet(),
  );
}

class AddFinancialYearBottomSheet extends StatefulWidget {
  const AddFinancialYearBottomSheet({super.key});

  @override
  State<AddFinancialYearBottomSheet> createState() =>
      _AddFinancialYearBottomSheetState();
}

class _AddFinancialYearBottomSheetState
    extends State<AddFinancialYearBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _fyNameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  String _currentYear = 'Yes';

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _fyNameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final initialDate = isStartDate
        ? _startDate ?? DateTime.now()
        : _endDate ?? _startDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: _textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);

        // Generate FY name from the selected start year.
        _fyNameController.text =
            '${picked.year}-${picked.year + 1}';

        // Clear end date if it is now earlier than start date.
        if (_endDate != null && !_endDate!.isAfter(picked)) {
          _endDate = null;
          _endDateController.clear();
        }
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) return;

    if (!_endDate!.isAfter(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End Date must be after Start Date.'),
        ),
      );
      return;
    }

    final financialYear = FinancialYearModel(
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      financialYearName: _fyNameController.text.trim(),
      isCurrent: _currentYear == 'Yes',
    );
Navigator.pop(context, financialYear);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
         constraints: BoxConstraints(
  maxHeight: MediaQuery.of(context).size.height * 0.75,
),
          decoration: const BoxDecoration(
            color: Colors.white,
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
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              label: 'Start Date',
                              controller: _startDateController,
                              onTap: () =>
                                  _selectDate(isStartDate: true),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _dateField(
                              label: 'End Date',
                              controller: _endDateController,
                              onTap: () =>
                                  _selectDate(isStartDate: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _fyNameField(),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _currentYearDropdown(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const CommonText(
                        text:
                            'Auto-filled from start date. Format: 2024-2025 or 2024-25',
                        fontSize: 11,
                        color: _hintColor,
                      ),
                    ],
                  ),
                ),
              ),
              _bottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
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
              text: 'Add Financial Year',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFFCBD0D8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: _decoration(
            hint: 'dd/mm/yyyy',
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 17,
              color: Colors.black87,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _fyNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('FY Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fyNameController,
          readOnly: true,
          decoration: _decoration(
            hint: 'e.g. 2024-2025',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _currentYearDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Mark as Current?'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _currentYear,
          isExpanded: true,
          decoration: _decoration(),
          items: const [
            DropdownMenuItem(
              value: 'Yes',
              child: Text('Yes — Current Year'),
            ),
            DropdownMenuItem(
              value: 'No',
              child: Text('No'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _currentYear = value);
            }
          },
        ),
      ],
    );
  }

  Widget _label(String value) {
    return RichText(
      text: TextSpan(
        text: value,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF44516A),
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: _primaryColor),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration({
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFB8C5D9),
        fontSize: 13,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFDCE4F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFDCE4F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: _primaryColor,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _bottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE8EDF4)),
        ),
      ),
      child:Row(
  children: [
    Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
        ),
        child: const Text('Cancel'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: CommonButton(
        text: 'Add Financial Year',
        height: 50,
        onPressed: _submit,
      ),
    ),
  ],
)
    );
  }
}

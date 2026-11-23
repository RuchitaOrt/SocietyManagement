
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/feature/Financial/presentation/bloc/FinancialMonthModel.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<FinancialMonthModel?> showAddFinancialMonthBottomSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<FinancialMonthModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AddFinancialMonthBottomSheet(),
  );
}

class AddFinancialMonthBottomSheet extends StatefulWidget {
  const AddFinancialMonthBottomSheet({super.key});

  @override
  State<AddFinancialMonthBottomSheet> createState() =>
      _AddFinancialMonthBottomSheetState();
}

class _AddFinancialMonthBottomSheetState
    extends State<AddFinancialMonthBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late final List<String> _financialYears;

  String? _selectedMonth;
  String? _selectedFinancialYear;

  // Replace this with the society name from your account/profile data.
  final String _societyName = 'Jainam';

  bool _isCurrentFinancialMonth = false;

  final int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    _financialYears = List.generate(
      21,
      (index) {
        final year = _currentYear - 10 + index;
        return '$year-${year + 1}';
      },
    );

    final currentMonth = DateTime.now().month;
    final currentFinancialYear =
        currentMonth >= 4 ? _currentYear : _currentYear - 1;

    _selectedFinancialYear =
        '$currentFinancialYear-${currentFinancialYear + 1}';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMonth == null || _selectedFinancialYear == null) {
      return;
    }

    final financialYearStart =
        int.parse(_selectedFinancialYear!.split('-')[0]);

    final monthIndex = _months.indexOf(_selectedMonth!) + 1;

    // Financial year: April to March.
    // April-December belong to the first year.
    // January-March belong to the second year.
    final selectedCalendarYear = monthIndex >= 4
        ? financialYearStart
        : financialYearStart + 1;

    final start = DateTime(
      selectedCalendarYear,
      monthIndex,
      1,
    );

    final end = DateTime(
      selectedCalendarYear,
      monthIndex + 1,
      0,
    );

    final financialMonth = FinancialMonthModel(
      financialMonthName: '$_selectedMonth $selectedCalendarYear',
      startDate: _formatDate(start),
      endDate: _formatDate(end),
      isCurrent: _isCurrentFinancialMonth,
    );

    Navigator.pop(context, financialMonth);
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
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      _sectionTitle('SOCIETY'),

                      const SizedBox(height: 12),

                      _label('Society'),

                      const SizedBox(height: 7),

                      TextFormField(
                        initialValue: _societyName,
                        readOnly: true,
                        decoration: _decoration(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: _textColor,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Society is fixed to your account.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB8C6D9),
                        ),
                      ),

                      const SizedBox(height: 22),

                      _sectionTitle('MONTH DETAILS'),

                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _financialYearDropdown(),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _monthDropdown(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _currentFinancialMonthCheckbox(),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFF9D5E5),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Start date and end date will be generated automatically based on the selected month and financial year.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textColor,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
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
              text: 'Add Financial Month',
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

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 9),
        const Divider(
          height: 1,
          color: Color(0xFFE8EDF4),
        ),
      ],
    );
  }

  Widget _financialYearDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Financial Year'),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedFinancialYear,
          isExpanded: true,
          decoration: _decoration(),
          items: _financialYears.map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text(
                year,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFinancialYear = value;
            });
          },
          validator: (value) =>
              value == null ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _monthDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Month'),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedMonth,
          isExpanded: true,
          hint: const Text(
            'Select Month',
            style: TextStyle(fontSize: 12),
          ),
          decoration: _decoration(),
          items: _months.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(
                month,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedMonth = value;
            });
          },
          validator: (value) =>
              value == null ? 'Please select a month' : null,
        ),
      ],
    );
  }

  Widget _currentFinancialMonthCheckbox() {
    return InkWell(
      onTap: () {
        setState(() {
          _isCurrentFinancialMonth =
              !_isCurrentFinancialMonth;
        });
      },
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: _isCurrentFinancialMonth,
              activeColor: _primaryColor,
              onChanged: (value) {
                setState(() {
                  _isCurrentFinancialMonth = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Mark as Current Financial Month',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String value) {
    return RichText(
      text: TextSpan(
        text: value,
        style: const TextStyle(
          fontSize: 11,
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

  InputDecoration _decoration() {
    return InputDecoration(
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
    );
  }

  Widget _bottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8EDF4),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                foregroundColor: _primaryColor,
                side: const BorderSide(
                  color: Color(0xFFD5B8C5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: CommonButton(
              text: 'Add',
              height: 50,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}

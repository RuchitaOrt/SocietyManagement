
import 'package:flutter/material.dart';

class BillingConfigurationSection extends StatefulWidget {
  final VoidCallback? onSave;

  const BillingConfigurationSection({
    super.key,
    this.onSave,
  });

  @override
  State<BillingConfigurationSection> createState() =>
      _BillingConfigurationSectionState();
}

class _BillingConfigurationSectionState
    extends State<BillingConfigurationSection> {
  static const Color primaryColor = Color(0xFFE93691);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);
  static const Color borderColor = Color(0xFFDCE4EF);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  final Map<String, TextEditingController> controllers = {
    'B1': TextEditingController(text: '1'),
    'B2': TextEditingController(text: '20'),
    'B3': TextEditingController(text: '11'),
    'B4': TextEditingController(text: '18'),
    'B5': TextEditingController(text: 'INV-'),
    'B6': TextEditingController(),
    'B12': TextEditingController(text: '3'),
    'B13': TextEditingController(text: '7'),
  };

  final Map<String, bool> switches = {
    'B7': true,
    'B8': false,
    'B9': false,
    'B11': false,
  };

  final Map<String, bool> expandedSections = {
    'payment': true,
    'invoice': true,
    'tax': true,
    'reminders': true,
  };

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _resetSettings() {
    controllers['B1']!.text = '1';
    controllers['B2']!.text = '20';
    controllers['B3']!.text = '11';
    controllers['B4']!.text = '18';
    controllers['B5']!.text = 'INV-';
    controllers['B6']!.clear();
    controllers['B12']!.text = '3';
    controllers['B13']!.text = '7';

    setState(() {
      switches['B7'] = true;
      switches['B8'] = false;
      switches['B9'] = false;
      switches['B11'] = false;
    });
  }

  void _saveSettings() {
    widget.onSave?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Billing settings saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required String keyName,
    required IconData icon,
    required Color iconColor,
    required int count,
  }) {
    final isExpanded = expandedSections[keyName] ?? true;

    return InkWell(
      onTap: () {
        setState(() {
          expandedSections[keyName] = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE8F1),
              Color(0xFFFFEFDC),
            ],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFFFC6DE),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count Settings',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String subtitle,
    required String keyName,
    required IconData icon,
    required Color iconColor,
    required int count,
    required List<Widget> children,
  }) {
    final isExpanded = expandedSections[keyName] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EAF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _sectionHeader(
            title: title,
            subtitle: subtitle,
            keyName: keyName,
            icon: icon,
            iconColor: iconColor,
            count: count,
          ),
          if (isExpanded) ...children,
        ],
      ),
    );
  }

  Widget _code(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDF5),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFFFC6DE),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 10,
          color: primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _numberField(
    String key, {
    double width = 75,
  }) {
    return SizedBox(
      width: width,
      height: 36,
      child: TextFormField(
        controller: controllers[key],
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.white,
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
    );
  }

  Widget _prefixField() {
    return SizedBox(
      width: 160,
      height: 36,
      child: TextFormField(
        controller: controllers['B5'],
        textAlign: TextAlign.end,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget _footerField() {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controllers['B6'],
        maxLines: 2,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'e.g. Thank you for your timely payment.',
          hintStyle: const TextStyle(fontSize: 11),
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget _helper(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: hintColor,
          size: 13,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: hintColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingRow({
    required String code,
    required String title,
    required Widget control,
    String? helper,
    Color? background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE8EDF4)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;

          return isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _code(code),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: control,
                    ),
                    if (helper != null) ...[
                      const SizedBox(height: 7),
                      _helper(helper),
                    ],
                  ],
                )
              : Row(
                  children: [
                    _code(code),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    control,
                    if (helper != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _helper(helper),
                      ),
                    ],
                  ],
                );
        },
      ),
    );
  }

  Widget _switchControl(String key) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: switches[key] ?? false,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFFEF3B9A),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD1D5DB),
          onChanged: (value) {
            setState(() {
              switches[key] = value;
            });
          },
        ),
        Text(
          switches[key] == true ? 'Yes' : 'No',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _paymentSection() {
    return _section(
      title: 'Payment Settings',
      subtitle: 'Bill generation schedule, due dates, grace period and interest rules',
      keyName: 'payment',
      icon: Icons.currency_rupee_rounded,
      iconColor: const Color(0xFF10B981),
      count: 4,
      children: [
        _settingRow(
          code: 'B1',
          title: 'Bills are auto-generated on day',
          control: _numberField('B1'),
          helper: 'System auto-generates maintenance bills on this day each month.',
        ),
        _settingRow(
          code: 'B2',
          title: 'Payment due day is',
          control: _numberField('B2'),
          helper: 'Residents must pay on or before this date to avoid charges.',
          background: const Color(0xFFF8FAFC),
        ),
        _settingRow(
          code: 'B3',
          title: 'Grace period after due date is',
          control: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _numberField('B3'),
              const SizedBox(width: 8),
              const Text('days', style: TextStyle(fontSize: 12)),
            ],
          ),
          helper: 'Interest is charged only after the grace period ends.',
        ),
        _settingRow(
          code: 'B4',
          title: 'Interest on overdue maintenance is',
          control: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _numberField('B4'),
              const SizedBox(width: 7),
              const Text('% per month', style: TextStyle(fontSize: 12)),
            ],
          ),
          helper: 'Applied monthly on outstanding amount after the grace period.',
          background: const Color(0xFFF8FAFC),
        ),
      ],
    );
  }

  Widget _invoiceSection() {
    return _section(
      title: 'Invoice & Receipt Settings',
      subtitle: 'Invoice numbering, receipt footer, bank details and QR code on receipts',
      keyName: 'invoice',
      icon: Icons.description_outlined,
      iconColor: const Color(0xFF8B5CF6),
      count: 4,
      children: [
        _settingRow(
          code: 'B5',
          title: 'Invoice number prefix',
          control: _prefixField(),
          helper: 'e.g. "INV-" → receipts will be INV-0001, INV-0002...',
        ),
        _settingRow(
          code: 'B6',
          title: 'Receipt footer note',
          control: _footerField(),
          background: const Color(0xFFF8FAFC),
        ),
        _settingRow(
          code: 'B7',
          title: 'Show society bank details on receipt',
          control: _switchControl('B7'),
          helper: 'Bank details printed on receipt',
        ),
        _settingRow(
          code: 'B8',
          title: 'Show UPI QR code on receipt',
          control: _switchControl('B8'),
          background: const Color(0xFFFCF2F8),
        ),
      ],
    );
  }

  Widget _taxSection() {
    return _section(
      title: 'Tax Configuration (GST)',
      subtitle: 'Configure GST applicability and rate for maintenance bills',
      keyName: 'tax',
      icon: Icons.receipt_long_rounded,
      iconColor: const Color(0xFFF59E0B),
      count: 1,
      children: [
        _settingRow(
          code: 'B9',
          title: 'GST applicable on maintenance',
          control: _switchControl('B9'),
        ),
      ],
    );
  }

  Widget _reminderSection() {
    return _section(
      title: 'Reminders & Notifications',
      subtitle: 'Auto-send bills and configure payment reminder schedules',
      keyName: 'reminders',
      icon: Icons.notifications_none_rounded,
      iconColor: const Color(0xFF3B82F6),
      count: 3,
      children: [
        _settingRow(
          code: 'B11',
          title: 'Auto-email bill to members on generation',
          control: _switchControl('B11'),
          helper: 'Admin sends manually when disabled',
        ),
        _settingRow(
          code: 'B12',
          title: 'Send payment reminder',
          control: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _numberField('B12'),
              const SizedBox(width: 8),
              const Text(
                'days before due date',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          helper: 'Automated reminder SMS/email sent to all unpaid members.',
          background: const Color(0xFFF8FAFC),
        ),
        _settingRow(
          code: 'B13',
          title: 'Send overdue reminder every',
          control: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _numberField('B13'),
              const SizedBox(width: 8),
              const Text(
                'days until paid',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          helper: 'Keeps reminding overdue members at this interval.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Billing Configuration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Configure payment rules, invoice settings, tax, and reminder policies.',
                    style: TextStyle(
                      fontSize: 12,
                      color: hintColor,
                    ),
                  ),
                ],
              ),
            ),
            // OutlinedButton.icon(
            //   onPressed: _resetSettings,
            //   icon: const Icon(Icons.refresh_rounded, size: 16),
            //   label: const Text('Reset'),
            //   style: OutlinedButton.styleFrom(
            //     foregroundColor: const Color(0xFF475569),
            //     side: const BorderSide(color: borderColor),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(9),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save_outlined, size: 16),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _paymentSection(),
        _invoiceSection(),
        _taxSection(),
        _reminderSection(),
      ],
    );
  }
}

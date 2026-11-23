import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/transaction_model.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../widgets/cashbook_widgets.dart';

class CreateTransactionScreen extends StatefulWidget {
  final TransactionType initialType;

  const CreateTransactionScreen({
    super.key,
    required this.initialType,
  });

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _partyController = TextEditingController();
  final _bankController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();

  late TransactionType _type;
  PaymentMode _mode = PaymentMode.cash;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _categoryController.dispose();
    _partyController.dispose();
    _bankController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: cashbookBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: cashbookBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: cashbookPink, width: 1.4),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _saving = true);

    final transaction = CashbookTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: _date,
      type: _type,
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      memberOrParty: _partyController.text.trim(),
      bank: _bankController.text.trim().isEmpty
          ? '—'
          : _bankController.text.trim(),
      mode: _mode,
      amount: amount,
      referenceNumber: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
    );

    context.read<TransactionBloc>().add(TransactionAdded(transaction));
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = _type == TransactionType.credit;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(isCredit ? 'Add Credit' : 'Add Debit'),
        backgroundColor: Colors.white,
        foregroundColor: cashbookNavy,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCredit
                      ? const Color(0xFFEAF8F0)
                      : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCredit ? Icons.trending_up : Icons.trending_down,
                      color: isCredit ? cashbookGreen : cashbookRed,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isCredit ? 'Money received' : 'Money paid',
                      style: TextStyle(
                        color: isCredit ? cashbookGreen : cashbookRed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<TransactionType>(
                value: _type,
                decoration: _decoration('Transaction type'),
                items: TransactionType.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _decoration('Amount (₹)', hint: 'Enter amount'),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  if (amount == null || amount <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                decoration: _decoration('Description', hint: 'Enter description'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _categoryController,
                decoration: _decoration('Category', hint: 'e.g. Maintenance'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Category is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _partyController,
                decoration: _decoration('Member / Party', hint: 'Enter member or party'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _bankController,
                decoration: _decoration('Bank', hint: 'Enter bank name (optional)'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<PaymentMode>(
                value: _mode,
                decoration: _decoration('Payment mode'),
                items: PaymentMode.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _mode = value);
                },
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(11),
                child: InputDecorator(
                  decoration: _decoration('Transaction date'),
                  child: Row(
                    children: [
                      Text('${_date.day.toString().padLeft(2, '0')}/'
                          '${_date.month.toString().padLeft(2, '0')}/${_date.year}'),
                      const Spacer(),
                      const Icon(Icons.calendar_month_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _referenceController,
                decoration: _decoration('Reference number (optional)'),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cashbookPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _saving ? 'Saving...' : 'Save Transaction',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

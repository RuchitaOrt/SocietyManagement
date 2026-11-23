class FinancialMonthModel {
  final String financialMonthName;
  final String startDate;
  final String endDate;
  final bool isCurrent;

  const FinancialMonthModel({
    required this.financialMonthName,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });
}
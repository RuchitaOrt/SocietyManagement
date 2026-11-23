
class FinancialYearModel {
  final String startDate;
  final String endDate;
  final String financialYearName;
  final bool isCurrent;

  const FinancialYearModel({
    required this.startDate,
    required this.endDate,
    required this.financialYearName,
    required this.isCurrent,
  });
}

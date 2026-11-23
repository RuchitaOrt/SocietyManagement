
class ExpenseCategoryModel {
  final String expenseName;
  final String expenseCode;
  final String? accountGroup;

  ExpenseCategoryModel({
    required this.expenseName,
    required this.expenseCode,
    this.accountGroup,
  });
}

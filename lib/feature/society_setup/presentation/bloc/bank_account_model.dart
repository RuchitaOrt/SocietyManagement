
class BankAccountModel {
  final String bankName;
  final String branchName;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String upiId;
  final double openingBalance;
  final String? qrImagePath;
  final bool isDefault;

  const BankAccountModel({
    required this.bankName,
    required this.branchName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.upiId,
    required this.openingBalance,
    this.qrImagePath,
    this.isDefault = false,
  });

  BankAccountModel copyWith({
    bool? isDefault,
  }) {
    return BankAccountModel(
      bankName: bankName,
      branchName: branchName,
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      upiId: upiId,
      openingBalance: openingBalance,
      qrImagePath: qrImagePath,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

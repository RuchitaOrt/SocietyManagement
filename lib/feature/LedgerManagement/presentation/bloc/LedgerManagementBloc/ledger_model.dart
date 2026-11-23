class LedgerModel {
  final String id;
  final String society;
  final String accountGroup;
  final String ledgerName;
  final String ledgerCode;
  final String ledgerType;
  final double openingBalance;
  final String balanceType;
  final bool isActive;

  const LedgerModel({
    required this.id,
    required this.society,
    required this.accountGroup,
    required this.ledgerName,
    required this.ledgerCode,
    required this.ledgerType,
    required this.openingBalance,
    required this.balanceType,
    this.isActive = true,
  });
}
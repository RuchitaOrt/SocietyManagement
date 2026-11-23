class MaintenanceHeadModel {
  final String head;
  final String chargeType;
  final double baseAmount;

  MaintenanceHeadModel({
    required this.head,
    required this.chargeType,
    required this.baseAmount,
  });
}

class BillModel {
  final String society;
  final String financialYear;
  final String financialMonth;
  final DateTime billDate;
  final int dueDays;
  final List<MaintenanceHeadModel> maintenanceHeads;
  final double arrears;
  final double discount;
  final String remark;
  final String flat;
  final String wing;
  final String owner;
  final String status;
  final DateTime createdAt;

  BillModel({
    required this.society,
    required this.financialYear,
    required this.financialMonth,
    required this.billDate,
    required this.dueDays,
    required this.maintenanceHeads,
    required this.arrears,
    required this.discount,
    required this.remark,
    this.flat = '-',
    this.wing = '-',
    this.owner = '-',
    this.status = 'Unpaid',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get subtotal =>
      maintenanceHeads.fold(0, (sum, item) => sum + item.baseAmount);

  double get totalAmount => subtotal + arrears - discount;
  BillModel copyWithStatus(String newStatus) {
  return BillModel(
    society: society,
    financialYear: financialYear,
    financialMonth: financialMonth,
    billDate: billDate,
    dueDays: dueDays,
    maintenanceHeads: maintenanceHeads,
    arrears: arrears,
    discount: discount,
    remark: remark,
    flat: flat,
    wing: wing,
    owner: owner,
    status: newStatus,
    createdAt: createdAt,
  );
}
}
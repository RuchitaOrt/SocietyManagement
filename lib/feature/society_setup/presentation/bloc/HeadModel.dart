class AreaChargeModel {
  final String area;
  final double charge;

  AreaChargeModel({
    required this.area,
    required this.charge,
  });

  Map<String, dynamic> toJson() => {
    'area': area,
    'charge': charge,
  };
}

class HeadModel {
  final String headName;
  final bool isAreaWise;
  final String? accountGroup;
  final String? linkedLedger;
  final String chargeType;
  final double chargeRate;
  final List<AreaChargeModel> areaCharges;

  HeadModel({
    required this.headName,
    required this.isAreaWise,
    this.accountGroup,
    this.linkedLedger,
    required this.chargeType,
    required this.chargeRate,
    this.areaCharges = const [],
  });
}
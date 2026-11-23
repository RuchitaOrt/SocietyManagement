class FlatModel {
  final String wing;
  final String flatType;
  final int floor;
  final String flatNumber;
  final int position;
  final double? area;

  const FlatModel({
    required this.wing,
    required this.flatType,
    required this.floor,
    required this.flatNumber,
    required this.position,
    this.area,
  });
}
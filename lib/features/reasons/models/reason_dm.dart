class ReasonDm {
  final int id;
  final String rCode;
  final String rName;
  final String useIn;
  final String label;

  ReasonDm({
    required this.id,
    required this.rCode,
    required this.rName,
    required this.useIn,
    required this.label,
  });

  factory ReasonDm.fromJson(Map<String, dynamic> json) {
    return ReasonDm(
      id: json['ID'],
      rCode: json['RCode'],
      rName: json['RName'],
      useIn: json['UseIn'],
      label: json['Lable'],
    );
  }
}

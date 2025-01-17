class SubgroupDm {
  final String icCode;
  final String icName;

  SubgroupDm({
    required this.icCode,
    required this.icName,
  });

  factory SubgroupDm.fromJson(Map<String, dynamic> json) {
    return SubgroupDm(
      icCode: json['ICCODE'],
      icName: json['ICNAME'],
    );
  }
}

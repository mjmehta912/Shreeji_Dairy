class Subgroup2Dm {
  final String ipackgCode;
  final String ipackgName;

  Subgroup2Dm({
    required this.ipackgCode,
    required this.ipackgName,
  });

  factory Subgroup2Dm.fromJson(Map<String, dynamic> json) {
    return Subgroup2Dm(
      ipackgCode: json['IPACKGCODE'],
      ipackgName: json['IPACKGNAME'],
    );
  }
}

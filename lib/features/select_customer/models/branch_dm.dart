class BranchDm {
  final String gdCode;
  final String gdName;

  BranchDm({
    required this.gdCode,
    required this.gdName,
  });

  factory BranchDm.fromJson(Map<String, dynamic> json) {
    return BranchDm(
      gdCode: json['GDCODE'],
      gdName: json['GDNAME'],
    );
  }
}

class CustomerDm {
  final String pCode;
  final String pName;

  CustomerDm({
    required this.pCode,
    required this.pName,
  });

  factory CustomerDm.fromJson(Map<String, dynamic> json) {
    return CustomerDm(
      pCode: json['PCODE'],
      pName: json['PNAME'],
    );
  }
}

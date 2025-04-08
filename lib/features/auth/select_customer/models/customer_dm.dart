class CustomerDm {
  final String pCode;
  final String pName;
  final String? deliDateOption;
  final String cCode;

  CustomerDm({
    required this.pCode,
    required this.pName,
    required this.deliDateOption,
    required this.cCode,
  });

  factory CustomerDm.fromJson(Map<String, dynamic> json) {
    return CustomerDm(
      pCode: json['PCODE'],
      pName: json['PNAME'],
      deliDateOption: json['DELIDATEOPTION'] ?? '',
      cCode: json['CCODE'] ?? '',
    );
  }
}

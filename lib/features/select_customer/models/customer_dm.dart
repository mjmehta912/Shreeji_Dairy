class CustomerDm {
  final String pCode;
  final String pName;
  final String? deliDateOption;

  CustomerDm({
    required this.pCode,
    required this.pName,
    required this.deliDateOption,
  });

  factory CustomerDm.fromJson(Map<String, dynamic> json) {
    return CustomerDm(
      pCode: json['PCODE'],
      pName: json['PNAME'],
      deliDateOption: json['DELIDATEOPTION'] ?? '',
    );
  }
}

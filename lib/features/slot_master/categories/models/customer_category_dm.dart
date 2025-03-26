class CustomerCategoryDm {
  final String cCode;
  final String cName;

  CustomerCategoryDm({
    required this.cCode,
    required this.cName,
  });

  factory CustomerCategoryDm.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryDm(
      cCode: json['CCODE'],
      cName: json['CNAME'],
    );
  }
}

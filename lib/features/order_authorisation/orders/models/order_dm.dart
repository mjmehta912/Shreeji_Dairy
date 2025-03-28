class OrderDm {
  final String invNo;
  final String date;
  final String pName;
  final String statusDesc;

  OrderDm({
    required this.invNo,
    required this.date,
    required this.pName,
    required this.statusDesc,
  });

  factory OrderDm.fromJson(Map<String, dynamic> json) {
    return OrderDm(
      invNo: json['INVNO'],
      date: json['DATE'],
      pName: json['PNAME'],
      statusDesc: json['StatusDesc'],
    );
  }
}

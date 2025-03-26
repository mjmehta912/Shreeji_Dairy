class OrderItemDm {
  final String invNo;
  final String pCode;
  final String iCode;
  final String icCode;
  final String date;
  final String iName;
  final String itemCompany;
  final String pName;
  final double orderQty;
  final double approvedQty;
  final int status;
  final String seName;
  final String dDate;
  final String dTime;
  final double stock;
  final int dispatched;
  final int percentage;

  OrderItemDm({
    required this.invNo,
    required this.pCode,
    required this.iCode,
    required this.icCode,
    required this.date,
    required this.iName,
    required this.itemCompany,
    required this.pName,
    required this.orderQty,
    required this.approvedQty,
    required this.status,
    required this.seName,
    required this.dDate,
    required this.dTime,
    required this.stock,
    required this.dispatched,
    required this.percentage,
  });

  factory OrderItemDm.fromJson(Map<String, dynamic> json) {
    return OrderItemDm(
      invNo: json['INVNO'],
      pCode: json['PCODE'],
      iCode: json['ICODE'],
      icCode: json['IcCode'],
      date: json['Date'],
      iName: json['INAME'],
      itemCompany: json['ItemCompany'],
      pName: json['PNAME'],
      orderQty: json['OrdQty'] ?? 0.0,
      approvedQty: json['ApprovedQty'] ?? 0.0,
      status: json['Status'] ?? 0,
      seName: json['SENAME'],
      dDate: json['DDate'],
      dTime: json['DTime'],
      stock: (json['Stock'] as num).toDouble(),
      dispatched: json['Dispetched'],
      percentage: json['Percentage'] ?? 0,
    );
  }
}

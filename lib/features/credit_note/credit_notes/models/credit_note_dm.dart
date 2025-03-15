class CreditNoteDm {
  final String pCode;
  final String pName;
  final String invNo;
  final String? remark;
  final String date;

  CreditNoteDm({
    required this.pCode,
    required this.pName,
    required this.invNo,
    this.remark,
    required this.date,
  });

  factory CreditNoteDm.fromJson(Map<String, dynamic> json) {
    return CreditNoteDm(
      pCode: json['PCODE'],
      pName: json['PNAME'],
      invNo: json['INVNO'],
      remark: json['Remark'],
      date: json['Date'],
    );
  }
}

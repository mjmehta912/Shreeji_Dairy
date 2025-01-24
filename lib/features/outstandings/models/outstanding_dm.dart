class OutstandingDm {
  final List<OutstandingDataDm> outstandings;
  final String outstandingAmount;

  OutstandingDm({
    required this.outstandings,
    required this.outstandingAmount,
  });

  factory OutstandingDm.fromJson(Map<String, dynamic> json) {
    return OutstandingDm(
      outstandings: (json['data'] as List)
          .map(
            (item) => OutstandingDataDm.fromJson(item),
          )
          .toList(),
      outstandingAmount: json['outstandingAmount'],
    );
  }
}

class OutstandingDataDm {
  final String pname;
  final String invNo;
  final String date;
  final String amount;
  final String paidAmount;
  final String outstanding;
  final String type;
  final String remarks;
  final String dbc;
  final String pCode;
  final String? docNo;
  final String bookCode;
  final int yearId;
  final String dueDate;
  final int other;
  final String? poNo;
  final String runningTotal;

  OutstandingDataDm({
    required this.pname,
    required this.invNo,
    required this.date,
    required this.amount,
    required this.paidAmount,
    required this.outstanding,
    required this.type,
    required this.remarks,
    required this.dbc,
    required this.pCode,
    this.docNo,
    required this.bookCode,
    required this.yearId,
    required this.dueDate,
    required this.other,
    this.poNo,
    required this.runningTotal,
  });

  factory OutstandingDataDm.fromJson(Map<String, dynamic> json) {
    return OutstandingDataDm(
      pname: json['pName'] ?? '',
      invNo: json['invNo'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? '',
      paidAmount: json['paidAmt'] ?? '',
      outstanding: json['outstanding'] ?? '',
      type: json['type'] ?? '',
      remarks: json['remarks'] ?? '',
      dbc: json['dbc'] ?? '',
      pCode: json['pCode'] ?? '',
      docNo: json['docNo'],
      bookCode: json['bookCode'] ?? '',
      yearId: json['yearID'] ?? 0,
      dueDate: json['dueDate'] ?? '',
      other: json['other'] ?? 0,
      poNo: json['poNo'],
      runningTotal: json['runningTotal'] ?? '',
    );
  }
}

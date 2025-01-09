class OutstandingDm {
  final List<OutstandingDataDm> outstandings;
  final double outstandingAmount;

  OutstandingDm({
    required this.outstandings,
    required this.outstandingAmount,
  });

  factory OutstandingDm.fromJson(Map<String, dynamic> json) {
    return OutstandingDm(
      outstandings: (json['data'] as List)
          .map((item) => OutstandingDataDm.fromJson(item))
          .toList(),
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
    );
  }
}

class OutstandingDataDm {
  final String pname;
  final String invNo;
  final String date;
  final double amount;
  final double outstanding;
  final String status;
  final String? transport;
  final int yearId;
  final String bookCode;
  final String dbc;

  OutstandingDataDm({
    required this.pname,
    required this.invNo,
    required this.date,
    required this.amount,
    required this.outstanding,
    required this.status,
    this.transport,
    required this.yearId,
    required this.bookCode,
    required this.dbc,
  });

  factory OutstandingDataDm.fromJson(Map<String, dynamic> json) {
    return OutstandingDataDm(
      pname: json['PNAME'],
      invNo: json['INVNO'],
      date: json['Date'],
      amount: (json['AMOUNT'] as num).toDouble(),
      outstanding: (json['OUTSTANDING'] as num).toDouble(),
      status: json['STATUS'],
      transport: json['Transport'],
      yearId: json['YearID'],
      bookCode: json['BOOKCODE'],
      dbc: json['DBC'],
    );
  }
}

class InvoiceDm {
  final String pname;
  final String invNo;
  final String date;
  final double amount;
  final double outstanding;
  final String status;
  final int yearId;
  final String bookCode;
  final String dbc;
  final int days;
  final String seCode;

  InvoiceDm({
    required this.pname,
    required this.invNo,
    required this.date,
    required this.amount,
    required this.outstanding,
    required this.status,
    required this.yearId,
    required this.bookCode,
    required this.dbc,
    required this.days,
    required this.seCode,
  });

  factory InvoiceDm.fromJson(Map<String, dynamic> json) {
    return InvoiceDm(
      pname: json['PNAME'],
      invNo: json['INVNO'],
      date: json['Date'],
      amount: (json['AMOUNT'] as num).toDouble(),
      outstanding: (json['OUTSTANDING'] as num).toDouble(),
      status: json['STATUS'],
      yearId: json['YearID'],
      bookCode: json['BOOKCODE'],
      dbc: json['DBC'],
      days: json['DAYS'],
      seCode: json['SECODE'],
    );
  }
}

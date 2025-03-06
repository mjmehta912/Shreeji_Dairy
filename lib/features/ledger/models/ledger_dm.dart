class LedgerDm {
  final int? id;
  final String? date;
  final String? invNo;
  final String? finYear;
  final String? dbc;
  final String? remarks;
  final String? pname;
  final String? pcode;
  final double? debit;
  final double? credit;
  final String? balance;
  final String? pnameC;
  final String? pcodeC;
  final int? yearId;
  final String? bookCode;
  final int? isParent;

  LedgerDm({
    this.id,
    this.date,
    this.invNo,
    this.finYear,
    this.dbc,
    this.remarks,
    this.pname,
    this.pcode,
    this.debit,
    this.credit,
    this.balance,
    this.pnameC,
    this.pcodeC,
    this.yearId,
    this.bookCode,
    this.isParent,
  });

  factory LedgerDm.fromJson(Map<String, dynamic> json) {
    return LedgerDm(
      id: _toInt(json['ID']),
      date: json['DATE'] as String?,
      invNo: json['INVNO'] as String?,
      finYear: json['FINYEAR'] as String?,
      dbc: json['DBC'] as String?,
      remarks: json['REMARKS'] as String?,
      pname: json['pname'] as String?,
      pcode: json['PCODE'] as String?,
      debit: _toDouble(json['Debit']),
      credit: _toDouble(json['Credit']),
      balance: json['BALANCE'] as String?,
      pnameC: json['PNAMEC'] as String?,
      pcodeC: json['PCODEC'] as String?,
      yearId: _toInt(json['YEARID']),
      bookCode: json['BOOKCODE'] as String?,
      isParent: _toInt(json['isParent']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

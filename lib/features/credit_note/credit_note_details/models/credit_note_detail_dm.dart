class CreditNoteDetailDm {
  final String invNo;
  final int srNo;
  final String iCode;
  final String iName;
  final int qty;
  final int status;
  final String imagePath;

  CreditNoteDetailDm({
    required this.invNo,
    required this.srNo,
    required this.iCode,
    required this.iName,
    required this.qty,
    required this.status,
    required this.imagePath,
  });

  factory CreditNoteDetailDm.fromJson(Map<String, dynamic> json) {
    return CreditNoteDetailDm(
      invNo: json['INVNO'],
      srNo: json['SRNO'],
      iCode: json['ICODE'],
      iName: json['INAME'],
      qty: json['QTY'],
      status: json['Status'],
      imagePath: json['ImagePath'],
    );
  }

  String get statusText {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "QC Checked";
      case 2:
        return "Passed by Accounting Team";
      case 3:
        return "Approved";
      case 4:
        return "Rejected";
      default:
        return "Unknown";
    }
  }
}

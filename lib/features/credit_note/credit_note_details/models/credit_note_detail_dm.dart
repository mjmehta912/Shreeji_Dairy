class CreditNoteDetailDm {
  final String invNo;
  final int srNo;
  final String iCode;
  final String iName;
  final int qty;
  final int status;
  final String imagePath;
  final String reason;

  CreditNoteDetailDm({
    required this.invNo,
    required this.srNo,
    required this.iCode,
    required this.iName,
    required this.qty,
    required this.status,
    required this.imagePath,
    required this.reason,
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
      reason: json['Reason'] ?? '',
    );
  }

  String get statusText {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "DOCK Checked";
      case 2:
        return "QC Done";
      case 3:
        return "Passed by Accounting team";
      case 4:
        return "Approved";
      default:
        return "Unknown";
    }
  }
}

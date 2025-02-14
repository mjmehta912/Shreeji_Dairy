class ItemForApprovalDm {
  final int? id;
  final String? iCode;
  final String? iName;
  final String? pCode;
  final String? pName;
  final String? date;
  final int? status;
  final String? billNo;
  final double? weight;
  final int? qty;
  final int? docQty;
  final double? docWeight;
  final String? docRemark;
  final String? docDate;
  final int? qcStatus;
  final String? qcRemark;
  final String? qcDate;
  final double? rate;
  final String? accRemark;
  final String? accDate;
  final int? approve;
  final String? approveRemark;
  final String? approveDate;
  final String? imagePath;
  final String? docImagePath;

  ItemForApprovalDm({
    this.id,
    this.iCode,
    this.iName,
    this.pCode,
    this.pName,
    this.date,
    this.status,
    this.billNo,
    this.weight,
    this.qty,
    this.docQty,
    this.docWeight,
    this.docRemark,
    this.docDate,
    this.qcStatus,
    this.qcRemark,
    this.qcDate,
    this.rate,
    this.accRemark,
    this.accDate,
    this.approve,
    this.approveRemark,
    this.approveDate,
    this.imagePath,
    this.docImagePath,
  });

  factory ItemForApprovalDm.fromJson(Map<String, dynamic> json) {
    return ItemForApprovalDm(
      id: json['ID'] as int?,
      iCode: json['ICODE'] as String?,
      iName: json['INAME'] as String?,
      pCode: json['PCODE'] as String?,
      pName: json['PNAME'] as String?,
      date: json['Date'] as String?,
      status: json['Status'] as int?,
      billNo: json['BillNo'] as String?,
      weight:
          (json['Weight'] != null) ? (json['Weight'] as num).toDouble() : null,
      qty: json['QTY'] as int?,
      docQty: json['DocQty'] as int?,
      docWeight: (json['DocWeight'] != null)
          ? (json['DocWeight'] as num).toDouble()
          : null,
      docRemark: json['DocRemark'] as String?,
      docDate: json['DocDate'] as String?,
      qcStatus: json['QCStatus'] as int?,
      qcRemark: json['QCRemark'] as String?,
      qcDate: json['QCDate'] as String?,
      rate: (json['Rate'] != null) ? (json['Rate'] as num).toDouble() : null,
      accRemark: json['AccRemark'] as String?,
      accDate: json['AccDate'] as String?,
      approve: json['Approve'] as int?,
      approveRemark: json['ApproveRemark'] as String?,
      approveDate: json['ApproveDate'] as String?,
      imagePath: json['ImagePath'] as String?,
      docImagePath: json['DocImagePath'] as String?,
    );
  }
}

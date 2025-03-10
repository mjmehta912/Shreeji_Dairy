class CreditNoteReasonDm {
  final String rCode;
  final String rName;

  CreditNoteReasonDm({
    required this.rCode,
    required this.rName,
  });

  factory CreditNoteReasonDm.fromJson(Map<String, dynamic> json) {
    return CreditNoteReasonDm(
      rCode: json['RCode'],
      rName: json['RName'],
    );
  }
}

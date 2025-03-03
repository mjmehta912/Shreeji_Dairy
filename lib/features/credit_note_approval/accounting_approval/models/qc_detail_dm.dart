class QcDetailDm {
  final String testPara;
  final String testResult;

  QcDetailDm({
    required this.testPara,
    required this.testResult,
  });

  factory QcDetailDm.fromJson(Map<String, dynamic> json) {
    return QcDetailDm(
      testPara: json['TestPara'],
      testResult: json['TestResult'],
    );
  }
}

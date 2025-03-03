class QcParaForApprovalDm {
  final String tpcode;
  final String testPara;
  final List<TestResultDm> testResult;

  QcParaForApprovalDm({
    required this.tpcode,
    required this.testPara,
    required this.testResult,
  });

  factory QcParaForApprovalDm.fromJson(Map<String, dynamic> json) {
    return QcParaForApprovalDm(
      tpcode: json['tpcode'],
      testPara: json['testPara'],
      testResult: (json['testResult'] as List<dynamic>)
          .map(
            (item) => TestResultDm.fromJson(item),
          )
          .toList(),
    );
  }
}

class TestResultDm {
  final String testResult;

  TestResultDm({
    required this.testResult,
  });

  factory TestResultDm.fromJson(Map<String, dynamic> json) {
    return TestResultDm(
      testResult: json['testResult'],
    );
  }
}

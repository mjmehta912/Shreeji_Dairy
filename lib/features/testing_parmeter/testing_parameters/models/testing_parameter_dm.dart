class TestingParameterDm {
  final String tpcode;
  final String testPara;
  final List<TestingResultDm> testResult;

  TestingParameterDm({
    required this.tpcode,
    required this.testPara,
    required this.testResult,
  });

  factory TestingParameterDm.fromJson(Map<String, dynamic> json) {
    return TestingParameterDm(
      tpcode: json['tpcode'],
      testPara: json['testPara'],
      testResult: (json['testResult'] as List<dynamic>)
          .map((item) => TestingResultDm.fromJson(item))
          .toList(),
    );
  }
}

class TestingResultDm {
  final String testResult;

  TestingResultDm({
    required this.testResult,
  });

  factory TestingResultDm.fromJson(Map<String, dynamic> json) {
    return TestingResultDm(
      testResult: json['testResult'],
    );
  }
}

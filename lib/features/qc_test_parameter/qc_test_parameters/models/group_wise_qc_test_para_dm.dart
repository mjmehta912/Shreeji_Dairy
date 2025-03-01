class GroupWiseQcTestParaDm {
  final String icname;
  final String iccode;
  final List<GroupWiseQcTestResultDm> testResult;

  GroupWiseQcTestParaDm({
    required this.icname,
    required this.iccode,
    required this.testResult,
  });

  factory GroupWiseQcTestParaDm.fromJson(Map<String, dynamic> json) {
    return GroupWiseQcTestParaDm(
      icname: json['icname'],
      iccode: json['iccode'],
      testResult: (json['testResult'] as List<dynamic>)
          .map((item) => GroupWiseQcTestResultDm.fromJson(item))
          .toList(),
    );
  }
}

class GroupWiseQcTestResultDm {
  final String tpcode;
  final String testPara;

  GroupWiseQcTestResultDm({
    required this.tpcode,
    required this.testPara,
  });

  factory GroupWiseQcTestResultDm.fromJson(Map<String, dynamic> json) {
    return GroupWiseQcTestResultDm(
      tpcode: json['tpcode'],
      testPara: json['testPara'],
    );
  }
}

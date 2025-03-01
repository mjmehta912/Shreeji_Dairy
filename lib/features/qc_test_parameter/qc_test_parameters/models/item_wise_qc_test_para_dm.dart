class ItemWiseQcTestParaDm {
  final String iname;
  final String icode;
  final List<ItemWiseQcTestResultDm> testResult;

  ItemWiseQcTestParaDm({
    required this.iname,
    required this.icode,
    required this.testResult,
  });

  factory ItemWiseQcTestParaDm.fromJson(Map<String, dynamic> json) {
    return ItemWiseQcTestParaDm(
      iname: json['iname'],
      icode: json['icode'],
      testResult: (json['testResult'] as List<dynamic>)
          .map((item) => ItemWiseQcTestResultDm.fromJson(item))
          .toList(),
    );
  }
}

class ItemWiseQcTestResultDm {
  final String tpcode;
  final String testPara;

  ItemWiseQcTestResultDm({
    required this.tpcode,
    required this.testPara,
  });

  factory ItemWiseQcTestResultDm.fromJson(Map<String, dynamic> json) {
    return ItemWiseQcTestResultDm(
      tpcode: json['tpcode'],
      testPara: json['testPara'],
    );
  }
}

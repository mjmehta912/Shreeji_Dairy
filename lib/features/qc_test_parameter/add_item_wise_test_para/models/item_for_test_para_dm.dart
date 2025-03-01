class ItemForTestParaDm {
  final String iCode;
  final String iName;

  ItemForTestParaDm({
    required this.iCode,
    required this.iName,
  });

  factory ItemForTestParaDm.fromJson(Map<String, dynamic> json) {
    return ItemForTestParaDm(
      iCode: json['ICODE'],
      iName: json['INAME'],
    );
  }
}

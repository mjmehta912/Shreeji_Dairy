class GroupDm {
  final String igCode;
  final String igName;

  GroupDm({
    required this.igCode,
    required this.igName,
  });

  factory GroupDm.fromJson(Map<String, dynamic> json) {
    return GroupDm(
      igCode: json['IGCODE'],
      igName: json['IGNAME'],
    );
  }
}

class ItemPartyWiseInvNoDm {
  final String invNo;

  ItemPartyWiseInvNoDm({
    required this.invNo,
  });

  factory ItemPartyWiseInvNoDm.fromJson(Map<String, dynamic> json) {
    return ItemPartyWiseInvNoDm(
      invNo: json['INVNO'],
    );
  }
}

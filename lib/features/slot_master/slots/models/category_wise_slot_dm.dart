class CategoryWiseSlotDm {
  final String dTime;
  final String slot;
  final int id;

  CategoryWiseSlotDm({
    required this.dTime,
    required this.slot,
    required this.id,
  });

  factory CategoryWiseSlotDm.fromJson(Map<String, dynamic> json) {
    return CategoryWiseSlotDm(
      dTime: json['DTime'],
      slot: json['Slot'],
      id: json['ID'],
    );
  }
}

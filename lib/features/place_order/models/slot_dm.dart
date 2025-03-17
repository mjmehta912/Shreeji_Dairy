class SlotDm {
  final String dTime;
  final String slot;

  SlotDm({
    required this.dTime,
    required this.slot,
  });

  factory SlotDm.fromJson(Map<String, dynamic> json) {
    return SlotDm(
      dTime: json['DTime'],
      slot: json['Slot'],
    );
  }
}

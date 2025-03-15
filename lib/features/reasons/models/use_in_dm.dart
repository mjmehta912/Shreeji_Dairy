class UseInDm {
  final String useIn;
  final String label;

  UseInDm({
    required this.useIn,
    required this.label,
  });

  factory UseInDm.fromJson(Map<String, dynamic> json) {
    return UseInDm(
      useIn: json['UseIn'],
      label: json['Lable'],
    );
  }
}

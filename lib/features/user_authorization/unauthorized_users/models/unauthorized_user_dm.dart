class UnauthorizedUserDm {
  final int userId;
  final String mobileNo;
  final String businessName;
  final String firstName;
  final String lastName;

  UnauthorizedUserDm({
    required this.userId,
    required this.mobileNo,
    required this.businessName,
    required this.firstName,
    required this.lastName,
  });

  factory UnauthorizedUserDm.fromJson(Map<String, dynamic> json) {
    return UnauthorizedUserDm(
      userId: json['UserId'],
      mobileNo: json['MobileNO'],
      businessName: json['Business'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
    );
  }
}

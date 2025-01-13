class UserDm {
  final int userId;
  final String firstName;
  final String lastName;
  final int userType;
  final bool appAccess;

  UserDm({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.appAccess,
  });

  factory UserDm.fromJson(Map<String, dynamic> json) {
    return UserDm(
      userId: json['UserId'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      userType: json['userType'],
      appAccess: json['AppAccess'],
    );
  }
}

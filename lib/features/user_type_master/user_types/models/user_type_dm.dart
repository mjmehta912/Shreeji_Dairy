class UserTypeDm {
  final int userType;
  final int activeUsers;
  final int inactiveUsers;
  final int totalUsers;
  final int appAccess;

  UserTypeDm({
    required this.userType,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.totalUsers,
    required this.appAccess,
  });

  factory UserTypeDm.fromJson(Map<String, dynamic> json) {
    return UserTypeDm(
      userType: json['USERTYPE'],
      activeUsers: json['ActiveUsers'],
      inactiveUsers: json['InactiveUsers'],
      totalUsers: json['TotalUsers'],
      appAccess: json['AppAccess'],
    );
  }
}

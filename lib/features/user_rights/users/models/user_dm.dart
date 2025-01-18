class UserDm {
  final int userId;
  final String firstName;
  final String lastName;
  final int userType;
  final bool appAccess;
  final String mobileNo;
  final String? pCodes;
  final String? seCodes;
  final String? storePCode;

  UserDm({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.appAccess,
    required this.mobileNo,
    required this.pCodes,
    required this.seCodes,
    required this.storePCode,
  });

  factory UserDm.fromJson(Map<String, dynamic> json) {
    return UserDm(
      userId: json['UserId'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      userType: json['userType'],
      appAccess: json['AppAccess'],
      mobileNo: json['MOBILENO'],
      pCodes: json['PCODEs'] ?? '',
      seCodes: json['SECODEs'] ?? '',
      storePCode: json['StorePCode'] ?? '',
    );
  }
}

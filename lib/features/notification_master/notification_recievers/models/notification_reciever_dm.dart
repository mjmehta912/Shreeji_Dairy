class NotificationRecieverDm {
  final int userId;
  final String firstName;
  final String lastName;
  final int nid;

  NotificationRecieverDm({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.nid,
  });

  factory NotificationRecieverDm.fromJson(Map<String, dynamic> json) {
    return NotificationRecieverDm(
      userId: json['USERID'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      nid: json['NID'],
    );
  }
}

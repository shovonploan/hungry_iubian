class User {
  int? userId;
  String userName;
  DateTime? dateOfBirth;
  DateTime accountCreated;
  String password;
  String? userType;
  double? credit;
  String? phone;
  String? email;
  String? passportNo;
  String? fatherName;
  String? motherName;

  User({
    this.userId,
    required this.userName,
    this.dateOfBirth,
    required this.accountCreated,
    required this.password,
    this.userType,
    this.credit,
    this.phone,
    this.email,
    this.passportNo,
    this.fatherName,
    this.motherName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'],
        userName: json['userName'],
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        accountCreated: DateTime.parse(json['accountCreated']),
        password: json['password'],
        userType: json['userType'],
        credit: json['credit']?.toDouble(),
        phone: json['phone'],
        email: json['email'],
        passportNo: json['passportNo'],
        fatherName: json['fatherName'],
        motherName: json['motherName'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'accountCreated': accountCreated.toIso8601String(),
        'password': password,
        'userType': userType,
        'credit': credit,
        'phone': phone,
        'email': email,
        'passportNo': passportNo,
        'fatherName': fatherName,
        'motherName': motherName,
      };
}

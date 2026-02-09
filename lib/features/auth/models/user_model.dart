class UserModel {
  final String userName;
  final String email;
  final String userId;

  UserModel({
    required this.userName,
    required this.email,
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
    'userName': userName,
    'email': email,
    'userId': userId,
  };
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userName: json['username'] ?? '',
    email: json['email'] ?? '',
    userId: json['userId'] ?? '',
  );
}

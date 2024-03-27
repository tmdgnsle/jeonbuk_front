// Register 모델
class RegisterModel {
  String id;
  String password;

  RegisterModel({required this.id, required this.password,});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    id: json['id'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
  };
}
const String NAME = 'name';
const String TOKEN = 'token';
const String USER_TYPE = 'type';

class UserModel {
  final String name;
  final String token;
  final String type;

  UserModel({this.name, this.token, this.type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(name: json[NAME] ?? '', token: json[TOKEN] ?? '', type: json[USER_TYPE] ?? '');
  }

  Map<String, dynamic> toJson(UserModel model) {
    return {
      NAME: model.name,
      TOKEN: model.token,
      USER_TYPE: model.type,
    };
  }
}

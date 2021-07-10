const String NAME = 'name';
const String MOBILE = 'phoneNumber';
const String USER_TYPE = 'type';

class UserModel {
  final String name;
  final String phoneNumber;
  final String type;

  UserModel({this.name, this.phoneNumber, this.type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(name: json[NAME] ?? '', phoneNumber: json[MOBILE] ?? '', type: json[USER_TYPE] ?? '');
  }

  Map<String, dynamic> toJson(UserModel model) {
    return {
      NAME: model.name,
      MOBILE: model.phoneNumber,
      USER_TYPE: model.type,
    };
  }
}

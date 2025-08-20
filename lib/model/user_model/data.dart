import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class UserDataModel {
  int? id;
  String? email;
  String? nickname;
  String? firstname;
  String? lastname;
  String? DisplayName;
  String? FirstName;
  String? LastName;
  String? avatar;
  String? mobile;
  //  String eland_bg;
  //  String eland_avatar;
  int? status;
  String? telv;
  String? emailv;
  String? statusStr;
  String? token;

  UserDataModel({
    this.id,
    this.email,
    this.nickname,
    this.firstname,
    this.lastname,
    this.DisplayName,
    this.FirstName,
    this.LastName,
    this.avatar,
    this.mobile,
    //    this.eland_bg,
    //    this.eland_avatar,
    this.status,
    this.telv,
    this.emailv,
    this.statusStr,
    this.token,
  });

  //反序列化
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    print('UserDataFromJson=====>${json}');
    return _$UserDataModelFromJson(json);
  }

  //序列化
  //  Map<String, dynamic> toJson() => _$UserDataToJson(this);
  Map<String, dynamic> toJson() {
    return _$UserDataModelToJson(this);
  }
}

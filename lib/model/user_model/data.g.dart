// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) {
  return UserDataModel(
    id: json['id'] as int?,
    email: json['email'] as String?,
    nickname: json['nickname'] as String?,
    firstname: json['firstname'] as String?,
    lastname: json['lastname'] as String?,
    DisplayName: json['DisplayName'] as String?,
    FirstName: json['FirstName'] as String?,
    LastName: json['LastName'] as String?,
    avatar: json['avatar'] as String?,
    mobile: json['mobile'] as String?,
    status: json['status'] as int?,
    telv: json['telv'] as String?,
    emailv: json['emailv'] as String?,
    statusStr: json['statusStr'] as String?,
  );
}

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'DisplayName': instance.DisplayName,
      'FirstName': instance.FirstName,
      'LastName': instance.LastName,
      'avatar': instance.avatar,
      'mobile': instance.mobile,
      'status': instance.status,
      'telv': instance.telv,
      'emailv': instance.emailv,
      'statusStr': instance.statusStr,
    };

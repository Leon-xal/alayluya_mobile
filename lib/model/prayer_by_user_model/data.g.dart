// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerByUserModel _$PrayerByUserModelFromJson(Map<String, dynamic> json) {
  return PrayerByUserModel(
    code: json['code'] as int,
    list:
        (json['list'] as List?)
            ?.map<PrayerByUserDatum>(
              (e) => e == null
                  ? PrayerByUserDatum.fromJson({})
                  : PrayerByUserDatum.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /*?.map((e) => e == null
            ? null
            : PrayerByUserDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$PrayerByUserModelToJson(PrayerByUserModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

PrayerByUserDatum _$PrayerByUserDatumFromJson(Map<String, dynamic> json) {
  return PrayerByUserDatum(
    key: json['key'] as int,
    f_uid: json['f_uid'] as int,
    f_avatar: json['f_avatar'] as String,
    f_uname: json['f_uname'] as String,
    my_is_follow: json['my_is_follow'] as bool,
  );
}

Map<String, dynamic> _$PrayerByUserDatumToJson(PrayerByUserDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'f_uid': instance.f_uid,
      'f_avatar': instance.f_avatar,
      'f_uname': instance.f_uname,
      'my_is_follow': instance.my_is_follow,
    };

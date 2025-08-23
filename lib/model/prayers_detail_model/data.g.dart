// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayersDetailModel _$PrayersDetailModelFromJson(Map<String, dynamic> json) {
  return PrayersDetailModel(
    code: json['code'] as int?,
    data: json['data'] == null
        ? null
        : PrayersDetailData.fromJson(json['data'] as Map<String, dynamic>),
    msg: json['msg'] as String?,
  );
}

Map<String, dynamic> _$PrayersDetailModelToJson(PrayersDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

PrayersDetailData _$PrayersDetailDataFromJson(Map<String, dynamic> json) {
  return PrayersDetailData(
    id: json['id'] as int?,
    author: json['author'] as String?,
    avatar: json['avatar'] as String?,
    time: json['time'] as String?,
    content: json['content'] as String?,
    cover: json['cover'] as String?,
    prayer: json['prayer'] as int?,
    iprayer: json['iprayer'] as bool?,
    content_app_link: json['content_app_link'] as String?,
  );
}

Map<String, dynamic> _$PrayersDetailDataToJson(PrayersDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'avatar': instance.avatar,
      'time': instance.time,
      'content': instance.content,
      'cover': instance.cover,
      'prayer': instance.prayer,
      'iprayer': instance.iprayer,
      'content_app_link': instance.content_app_link,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) {
  return ReplyModel(
    json['msg'] as String,
    json['code'] as int,
    (json['list'] as List?)
            ?.map<ReplyListDatum>(
              (e) => e == null
                  ? ReplyListDatum.fromJson({})
                  : ReplyListDatum.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /*?.map((e) => e == null
            ? null
            : ReplyListDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
  );
}

Map<String, dynamic> _$ReplyModelToJson(ReplyModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'list': instance.list,
    };

ReplyListDatum _$ReplyListDatumFromJson(Map<String, dynamic> json) {
  return ReplyListDatum(
    json['key'] as int,
    json['user_name'] as String,
    json['avatar'] as String,
    json['reply_id'] as int,
    json['comment_id'] as int,
    json['reply_content'] as String,
    json['reply_time'] as String,
    json['user_id'] as int,
  );
}

Map<String, dynamic> _$ReplyListDatumToJson(ReplyListDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'user_name': instance.user_name,
      'avatar': instance.avatar,
      'reply_id': instance.reply_id,
      'comment_id': instance.comment_id,
      'reply_content': instance.reply_content,
      'reply_time': instance.reply_time,
      'user_id': instance.user_id,
    };

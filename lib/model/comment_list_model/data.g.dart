// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return CommentModel(
    json['msg'] as String,
    json['code'] as int,
    (json['list'] as List<dynamic>?)
            ?.map<CommentListDatum>(
              (e) => e == null
                  ? CommentListDatum(0, '', 0, '', '', '', 0, 0, 0)
                  : CommentListDatum.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'list': instance.list,
    };

CommentListDatum _$CommentListDatumFromJson(Map<String, dynamic> json) {
  return CommentListDatum(
    json['key'] as int,
    json['avatar'] as String,
    json['comment_id'] as int,
    json['user_name'] as String,
    json['comment_content'] as String,
    json['comment_time'] as String,
    json['like_num'] as int,
    json['reply_num'] as int,
    json['user_id'] as int,
  )..ilike = json['ilike'] as bool;
}

Map<String, dynamic> _$CommentListDatumToJson(CommentListDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'avatar': instance.avatar,
      'comment_id': instance.comment_id,
      'user_name': instance.user_name,
      'comment_content': instance.comment_content,
      'comment_time': instance.comment_time,
      'like_num': instance.like_num,
      'ilike': instance.ilike,
      'reply_num': instance.reply_num,
      'user_id': instance.user_id,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDetailModel _$ArticleDetailModelFromJson(Map<String, dynamic> json) {
  return ArticleDetailModel(
    code: json['code'] as int,
    data: json['data'] == null
        ? null
        : ArticleDetailData.fromJson(json['data'] as Map<String, dynamic>),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ArticleDetailModelToJson(ArticleDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

ArticleDetailData _$ArticleDetailDataFromJson(Map<String, dynamic> json) {
  return ArticleDetailData(
    id: json['id'] as int,
    title: json['title'] as String,
    time: json['time'] as String,
    article_cate: json['article_cate'] as String,
    content: json['content'] as String,
    read: json['read'] as int,
    like: json['like'] as int,
    ilike: json['ilike'] as bool,
    prayer: json['prayer'] as int,
    iprayer: json['iprayer'] as bool,
    eland_id: json['eland_id'] as int,
    eland_pic: json['eland_pic'] as String,
    eland_name: json['eland_name'] as String,
    eland_desc: json['eland_desc'] as String,
    eland_follow: json['eland_follow'] as int,
    eland_ifollow: json['eland_ifollow'] as bool,
    tags: (json['tags'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleDetailTags.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    content_link: json['content_link'] as String,
    content_app_link: json['content_app_link'] as String,
    MobileViewUrl: json['MobileViewUrl'] as String,
    MobileAppViewUrl: json['MobileAppViewUrl'] as String,
    cover: json['cover'] as String,
    comment_num: json['comment_num'] as int,
  );
}

Map<String, dynamic> _$ArticleDetailDataToJson(ArticleDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'time': instance.time,
      'article_cate': instance.article_cate,
      'content': instance.content,
      'read': instance.read,
      'like': instance.like,
      'ilike': instance.ilike,
      'prayer': instance.prayer,
      'iprayer': instance.iprayer,
      'eland_id': instance.eland_id,
      'eland_pic': instance.eland_pic,
      'eland_name': instance.eland_name,
      'eland_desc': instance.eland_desc,
      'eland_follow': instance.eland_follow,
      'eland_ifollow': instance.eland_ifollow,
      'tags': instance.tags,
      'content_link': instance.content_link,
      'content_app_link': instance.content_app_link,
      'MobileViewUrl': instance.MobileViewUrl,
      'MobileAppViewUrl': instance.MobileAppViewUrl,
      'cover': instance.cover,
      'comment_num': instance.comment_num,
    };

ArticleDetailTags _$ArticleDetailTagsFromJson(Map<String, dynamic> json) {
  return ArticleDetailTags(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$ArticleDetailTagsToJson(ArticleDetailTags instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

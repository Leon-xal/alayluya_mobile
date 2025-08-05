// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLikeListModel _$ArticleLikeListModelFromJson(Map<String, dynamic> json) {
  return ArticleLikeListModel(
    code: json['code'] as int,
    list: (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleLikeListDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ArticleLikeListModelToJson(
        ArticleLikeListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ArticleLikeListDatum _$ArticleLikeListDatumFromJson(Map<String, dynamic> json) {
  return ArticleLikeListDatum(
    key: json['key'] as int,
    id: json['id'] as int,
    eland_id: json['eland_id'] as int,
    account_id: json['account_id'] as int,
    pic: json['pic'] as String,
    title: json['title'] as String,
    desc: json['desc'] as String,
    author: json['author'] as String,
    like: json['like'] as int,
    ilike: json['ilike'] as bool,
    prayer: json['prayer'] as int,
    iprayer: json['iprayer'] as bool,
    tags: (json['tags'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleLikeListTags.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ArticleLikeListDatumToJson(
        ArticleLikeListDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'id': instance.id,
      'eland_id': instance.eland_id,
      'account_id': instance.account_id,
      'pic': instance.pic,
      'title': instance.title,
      'desc': instance.desc,
      'author': instance.author,
      'like': instance.like,
      'ilike': instance.ilike,
      'prayer': instance.prayer,
      'iprayer': instance.iprayer,
      'tags': instance.tags,
    };

ArticleLikeListTags _$ArticleLikeListTagsFromJson(Map<String, dynamic> json) {
  return ArticleLikeListTags(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$ArticleLikeListTagsToJson(
        ArticleLikeListTags instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

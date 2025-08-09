// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleListModel _$ArticleListModelFromJson(Map<String, dynamic> json) {
  return ArticleListModel(
    code: json['code'] as int,
    list: (json['list'] as List?)
        ?.map<ArticleListDatum>(
          (e) => e == null
              ? ArticleListDatum()
              : ArticleListDatum.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map((e) => e == null
            ? null
            : ArticleListDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ArticleListModelToJson(ArticleListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ArticleListDatum _$ArticleListDatumFromJson(Map<String, dynamic> json) {
  return ArticleListDatum(
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
    tags: (json['tags'] as List?)
        ?.map<ArticleListTags>(
          (e) => e == null
              ? ArticleListTags()
              : ArticleListTags.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map(
          (e) => e == null
              ? null
              : ArticleListTags.fromJson(e as Map<String, dynamic>),
        )
        ?.toList(),*/
  );
}

Map<String, dynamic> _$ArticleListDatumToJson(ArticleListDatum instance) =>
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

ArticleListTags _$ArticleListTagsFromJson(Map<String, dynamic> json) {
  return ArticleListTags(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$ArticleListTagsToJson(ArticleListTags instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};

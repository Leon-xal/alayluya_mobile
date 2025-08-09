// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElandPrayersListModel _$ElandPrayersListModelFromJson(
  Map<String, dynamic> json,
) {
  return ElandPrayersListModel(
    code: json['code'] as int,
    list:
        (json['list'] as List?)
            ?.map<ElandPrayersListDatum>(
              (e) => e == null
                  ? ElandPrayersListDatum.fromJson({})
                  : ElandPrayersListDatum.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /*?.map((e) => e == null
            ? null
            : ElandPrayersListDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ElandPrayersListModelToJson(
  ElandPrayersListModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'list': instance.list,
  'msg': instance.msg,
};

ElandPrayersListDatum _$ElandPrayersListDatumFromJson(
  Map<String, dynamic> json,
) {
  return ElandPrayersListDatum(
    key: json['key'] as int,
    id: json['id'] as int,
    pic: json['pic'] as String,
    title: json['title'] as String,
    desc: json['desc'] as String,
    author: json['author'] as String,
    like: json['like'] as int,
    ilike: json['ilike'] as bool,
    prayer: json['prayer'] as int,
    iprayer: json['iprayer'] as bool,
    tags:
        (json['tags'] as List?)
            ?.map<ElandPrayersListTags>(
              (e) => e == null
                  ? ElandPrayersListTags.fromJson({})
                  : ElandPrayersListTags.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /*?.map(
          (e) => e == null
              ? null
              : ElandPrayersListTags.fromJson(e as Map<String, dynamic>),
        )
        ?.toList(),*/
  );
}

Map<String, dynamic> _$ElandPrayersListDatumToJson(
  ElandPrayersListDatum instance,
) => <String, dynamic>{
  'key': instance.key,
  'id': instance.id,
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

ElandPrayersListTags _$ElandPrayersListTagsFromJson(Map<String, dynamic> json) {
  return ElandPrayersListTags(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$ElandPrayersListTagsToJson(
  ElandPrayersListTags instance,
) => <String, dynamic>{'name': instance.name, 'value': instance.value};

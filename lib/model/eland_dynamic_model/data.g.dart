// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElandDynamicModel _$ElandDynamicModelFromJson(Map<String, dynamic> json) {
  return ElandDynamicModel(
    code: json['code'] as int,
    list: (json['list'] as List?)
        ?.map<ElandDynamicDatum>(
          (e) => e == null
              ? ElandDynamicDatum()
              : ElandDynamicDatum.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map((e) => e == null
            ? null
            : ElandDynamicDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ElandDynamicModelToJson(ElandDynamicModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ElandDynamicDatum _$ElandDynamicDatumFromJson(Map<String, dynamic> json) {
  return ElandDynamicDatum(
    key: json['key'] as int?,
    id: json['id'] as int?,
    eland_id: json['eland_id'] as int?,
    eland_name: json['eland_name'] as String?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    eland_pic: json['eland_pic'] as String?,
    time: json['time'] as String?,
    type: json['type'] as int?,
    type_name: json['type_name'] as String?,
    type_val: json['type_val'] as String?,
    collect: json['collect'] as int?,
    icollect: json['icollect'] as bool?,
    IsFeatured: json['IsFeatured'] as bool?,
    tags:
        (json['tags'] as List?)
            ?.map<ElandDynamicTags>(
              (e) => e == null
                  ? ElandDynamicTags()
                  : ElandDynamicTags.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [], // Provide a default empty list if 'list' is null
    /*?.map(
          (e) => e == null
              ? null
              : ElandDynamicTags.fromJson(e as Map<String, dynamic>),
        )
        ?.toList(),*/
    pics: (json['pics'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ElandDynamicDatumToJson(ElandDynamicDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'id': instance.id,
      'eland_id': instance.eland_id,
      'eland_name': instance.eland_name,
      'title': instance.title,
      'content': instance.content,
      'eland_pic': instance.eland_pic,
      'time': instance.time,
      'type': instance.type,
      'type_name': instance.type_name,
      'type_val': instance.type_val,
      'collect': instance.collect,
      'icollect': instance.icollect,
      'IsFeatured': instance.IsFeatured,
      'tags': instance.tags,
      'pics': instance.pics,
    };

ElandDynamicTags _$ElandDynamicTagsFromJson(Map<String, dynamic> json) {
  return ElandDynamicTags(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$ElandDynamicTagsToJson(ElandDynamicTags instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElandCateModel _$ElandCateModelFromJson(Map<String, dynamic> json) {
  return ElandCateModel(
    code: json['code'] as int,
    list: (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : ElandCateDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ElandCateModelToJson(ElandCateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ElandCateDatum _$ElandCateDatumFromJson(Map<String, dynamic> json) {
  return ElandCateDatum(
    key: json['key'] as int,
    cateid: json['cateid'] as int,
    catename: json['catename'] as String,
  );
}

Map<String, dynamic> _$ElandCateDatumToJson(ElandCateDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'cateid': instance.cateid,
      'catename': instance.catename,
    };

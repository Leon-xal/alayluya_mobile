// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleCateModel _$ArticleCateModelFromJson(Map<String, dynamic> json) {
  return ArticleCateModel(
    code: json['code'] as int,
    list: (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleCateDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ArticleCateModelToJson(ArticleCateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ArticleCateDatum _$ArticleCateDatumFromJson(Map<String, dynamic> json) {
  return ArticleCateDatum(
    key: json['key'] as int,
    cateid: json['cateid'] as int,
    catename: json['catename'] as String,
    catepic: (json['catepic'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleCatePic.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ArticleCateDatumToJson(ArticleCateDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'cateid': instance.cateid,
      'catename': instance.catename,
      'catepic': instance.catepic,
    };

ArticleCatePic _$ArticleCatePicFromJson(Map<String, dynamic> json) {
  return ArticleCatePic(
    pic: json['pic'] as String,
    type: json['type'] as int,
    type_name: json['type_name'] as String,
    type_val: json['type_val'] as String,
  );
}

Map<String, dynamic> _$ArticleCatePicToJson(ArticleCatePic instance) =>
    <String, dynamic>{
      'pic': instance.pic,
      'type': instance.type,
      'type_name': instance.type_name,
      'type_val': instance.type_val,
    };

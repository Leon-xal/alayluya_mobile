// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElandListModel _$ElandListModelFromJson(Map<String, dynamic> json) {
  return ElandListModel(
    code: json['code'] as int?,
    list: (json['list'] as List?)
        ?.map<ElandListDatum>(
          (e) => e == null
              ? ElandListDatum()
              : ElandListDatum.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map((e) => e == null
            ? null
            : ElandListDatum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ElandListModelToJson(ElandListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'msg': instance.msg,
    };

ElandListDatum _$ElandListDatumFromJson(Map<String, dynamic> json) {
  return ElandListDatum(
    key: json['key'] as int?,
    eland_id: json['eland_id'] as int?,
    eland_name: json['eland_name'] as String?,
    eland_desc: json['eland_desc'] as String?,
    eland_pic: json['eland_pic'] as String?,
    eland_has_news: json['eland_has_news'] as bool?,
    follow: json['follow'] as int?,
    ifollow: json['ifollow'] as bool?,
  );
}

Map<String, dynamic> _$ElandListDatumToJson(ElandListDatum instance) =>
    <String, dynamic>{
      'key': instance.key,
      'eland_id': instance.eland_id,
      'eland_name': instance.eland_name,
      'eland_desc': instance.eland_desc,
      'eland_pic': instance.eland_pic,
      'eland_has_news': instance.eland_has_news,
      'follow': instance.follow,
      'ifollow': instance.ifollow,
    };

import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandDynamicModel {
  int code;
  List<ElandDynamicDatum> list;
  String msg;

  ElandDynamicModel({
    this.code,
    this.list,
    this.msg,
  });

  //反序列化
  factory ElandDynamicModel.fromJson(Map<String, dynamic> json) => _$ElandDynamicModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDynamicModelToJson(this);
}

@JsonSerializable()
class ElandDynamicDatum {
  int key;
  int id;
  int eland_id;
  String eland_name;
  String title;
  String content;
  String eland_pic;
  String time;
  int type;
  String type_name;
  String type_val;
  int collect;
  bool icollect;
  bool IsFeatured;
  List<ElandDynamicTags> tags;
  List<String> pics;

  ElandDynamicDatum({
    this.key,
    this.id,
    this.eland_id,
    this.eland_name,
    this.title,
    this.content,
    this.eland_pic,
    this.time,
    this.type,
    this.type_name,
    this.type_val,
    this.collect,
    this.icollect,
    this.IsFeatured,
    this.tags,
    this.pics,
  });

  //反序列化
  factory ElandDynamicDatum.fromJson(Map<String, dynamic> json) => _$ElandDynamicDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDynamicDatumToJson(this);
}

@JsonSerializable()
class ElandDynamicTags {
  String name;
  String value;
  ElandDynamicTags({
    this.name,
    this.value,
  });

  //反序列化
  factory ElandDynamicTags.fromJson(Map<String, dynamic> json) =>
      _$ElandDynamicTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDynamicTagsToJson(this);
}
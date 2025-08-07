import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandListModel {
  int code;
  List<ElandListDatum> list;
  String msg;

  ElandListModel({
    required this.code,
    required this.list,
    required this.msg,
  }) 

  //反序列化
  factory ElandListModel.fromJson(Map<String, dynamic> json) => _$ElandListModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandListModelToJson(this);
}

@JsonSerializable()
class ElandListDatum {
  int key;
  int eland_id;
  String eland_name;
  String eland_desc;
  String eland_pic;
  bool eland_has_news;
  int follow;
  bool ifollow;

  ElandListDatum({
    required this.key,
    required this.eland_id,
    required this.eland_name,
    required this.eland_desc,
    required this.eland_pic,
    required this.eland_has_news,
    required this.follow,
    required this.ifollow,
  }) 

  //反序列化
  factory ElandListDatum.fromJson(Map<String, dynamic> json) => _$ElandListDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandListDatumToJson(this);
}
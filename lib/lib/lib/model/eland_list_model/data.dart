import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandListModel {
  int? code;
  List<ElandListDatum>? list;
  String? msg;

  ElandListModel({this.code, this.list, this.msg});

  factory ElandListModel.fromJson(Map<String, dynamic> json) =>
      _$ElandListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElandListModelToJson(this);
}

@JsonSerializable()
class ElandListDatum {
  int? key;
  int? eland_id;
  String? eland_name;
  String? eland_desc;
  String? eland_pic;
  bool? eland_has_news;
  int? follow;
  bool? ifollow;

  ElandListDatum({
    this.key,
    this.eland_id,
    this.eland_name,
    this.eland_desc,
    this.eland_pic,
    this.eland_has_news,
    this.follow,
    this.ifollow,
  });

  factory ElandListDatum.fromJson(Map<String, dynamic> json) =>
      _$ElandListDatumFromJson(json);

  Map<String, dynamic> toJson() => _$ElandListDatumToJson(this);
}

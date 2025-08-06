import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ArticleLikeListModel {
  int code;
  List<ArticleLikeListDatum> list;
  String msg;

  ArticleLikeListModel({
    required this.code,
    required this.list,
    required this.msg,
  });

  //反序列化
  factory ArticleLikeListModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleLikeListModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleLikeListModelToJson(this);
}

@JsonSerializable()
class ArticleLikeListDatum {
  int key;
  int id;
  int eland_id;
  int account_id;
  String pic;
  String title;
  String desc;
  String author;
  int like;
  bool ilike;
  int prayer;
  bool iprayer;
  List<ArticleLikeListTags> tags;

  ArticleLikeListDatum({
    required this.key,
    required this.id,
    required this.eland_id,
    required this.account_id,
    required this.pic,
    required this.title,
    required this.desc,
    required this.author,
    required this.like,
    required this.ilike,
    required this.prayer,
    required this.iprayer,
    required this.tags,
  });

  //反序列化
  factory ArticleLikeListDatum.fromJson(Map<String, dynamic> json) =>
      _$ArticleLikeListDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleLikeListDatumToJson(this);
}

@JsonSerializable()
class ArticleLikeListTags {
  String name;
  String value;
  ArticleLikeListTags({required this.name, required this.value});

  //反序列化
  factory ArticleLikeListTags.fromJson(Map<String, dynamic> json) =>
      _$ArticleLikeListTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleLikeListTagsToJson(this);
}

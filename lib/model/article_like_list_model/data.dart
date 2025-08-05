import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ArticleLikeListModel {
  int code;
  List<ArticleLikeListDatum> list;
  String msg;

  ArticleLikeListModel({
    this.code,
    this.list,
    this.msg,
  });

  //反序列化
  factory ArticleLikeListModel.fromJson(Map<String, dynamic> json) => _$ArticleLikeListModelFromJson(json);
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
    this.key,
    this.id,
    this.eland_id,
    this.account_id,
    this.pic,
    this.title,
    this.desc,
    this.author,
    this.like,
    this.ilike,
    this.prayer,
    this.iprayer,
    this.tags,
  });

  //反序列化
  factory ArticleLikeListDatum.fromJson(Map<String, dynamic> json) => _$ArticleLikeListDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleLikeListDatumToJson(this);
}

@JsonSerializable()
class ArticleLikeListTags {
  String name;
  String value;
  ArticleLikeListTags({
    this.name,
    this.value,
  });

  //反序列化
  factory ArticleLikeListTags.fromJson(Map<String, dynamic> json) =>
      _$ArticleLikeListTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleLikeListTagsToJson(this);
}
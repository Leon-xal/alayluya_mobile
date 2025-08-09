import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ArticleListModel {
  int? code;
  List<ArticleListDatum>? list;
  String? msg;

  ArticleListModel({
    this.code,
    this.list,
    this.msg,
  });

  //反序列化
  factory ArticleListModel.fromJson(Map<String, dynamic> json) => _$ArticleListModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleListModelToJson(this);
}

@JsonSerializable()
class ArticleListDatum {
  int? key;
  int? id;
  int? eland_id;
  int? account_id;
  String? pic;
  String? title;
  String? desc;
  String? author;
  int? like;
  bool? ilike;
  int? prayer;
  bool? iprayer;
  List<ArticleListTags>? tags;

  ArticleListDatum({
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
  factory ArticleListDatum.fromJson(Map<String, dynamic> json) => _$ArticleListDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleListDatumToJson(this);
}

@JsonSerializable()
class ArticleListTags {
  String? name;
  String? value;
  ArticleListTags({
    this.name,
    this.value,
  });

  //反序列化
  factory ArticleListTags.fromJson(Map<String, dynamic> json) =>
      _$ArticleListTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleListTagsToJson(this);
}
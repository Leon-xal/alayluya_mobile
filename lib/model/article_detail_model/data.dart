import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ArticleDetailModel {
  int? code;
  ArticleDetailData? data;
  String? msg;

  ArticleDetailModel({
    this.code,
    this.data,
    this.msg,
  });

  //反序列化
  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) => _$ArticleDetailModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleDetailModelToJson(this);
}

@JsonSerializable()
class ArticleDetailData {
  int? id;
  String? title;
  String? time;
  String? article_cate;
  String? content;
  int? read;
  int? like;
  bool? ilike;
  int? prayer;
  bool? iprayer;
  int? eland_id;
  String? eland_pic;
  String? eland_name;
  String? eland_desc;
  int? eland_follow;
  bool? eland_ifollow;
  List<ArticleDetailTags>? tags;
  String? content_link;
  String? content_app_link;
  String? MobileViewUrl;
  String? MobileAppViewUrl;
  String? cover;
  int? comment_num;

  ArticleDetailData({
    this.id,
    this.title,
    this.time,
    this.article_cate,
    this.content,
    this.read,
    this.like,
    this.ilike,
    this.prayer,
    this.iprayer,
    this.eland_id,
    this.eland_pic,
    this.eland_name,
    this.eland_desc,
    this.eland_follow,
    this.eland_ifollow,
    this.tags,
    this.content_link,
    this.content_app_link,
    this.MobileViewUrl,
    this.MobileAppViewUrl,
    this.cover,
    this.comment_num,
  });

  //反序列化
  factory ArticleDetailData.fromJson(Map<String, dynamic> json) {
//    print('UserDataFromJson=====>${json}');
    return _$ArticleDetailDataFromJson(json);
  }

  //序列化
  Map<String, dynamic> toJson() {
    return _$ArticleDetailDataToJson(this);
  }
}

@JsonSerializable()
class ArticleDetailTags {
  String? name;
  String? value;
  ArticleDetailTags({
    this.name,
    this.value,
  });

  //反序列化
  factory ArticleDetailTags.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleDetailTagsToJson(this);
}
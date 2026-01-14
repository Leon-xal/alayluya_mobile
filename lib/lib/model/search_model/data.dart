import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class SearchModel {
  int? code;
  SearchData? data;
  String? msg;

  SearchModel({this.code, this.data, this.msg});

  //反序列化
  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}

@JsonSerializable()
class SearchData {
  List<SearchSuggested>? suggested;
  List<SearchHistory>? history;

  SearchData({this.suggested, this.history});

  //反序列化
  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}

@JsonSerializable()
class SearchSuggested {
  int? key;
  String? title;
  SearchSuggested({this.key, this.title});

  //反序列化
  factory SearchSuggested.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestedFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SearchSuggestedToJson(this);
}

@JsonSerializable()
class SearchHistory {
  int? key;
  String? title;
  SearchHistory({this.key, this.title});

  //反序列化
  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);
}

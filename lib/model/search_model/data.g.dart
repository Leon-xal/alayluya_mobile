// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) {
  return SearchModel(
    code: json['code'] as int,
    data: json['data'] == null
        ? null
        : SearchData.fromJson(json['data'] as Map<String, dynamic>),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

SearchData _$SearchDataFromJson(Map<String, dynamic> json) {
  return SearchData(
    suggested:
        (json['suggested'] as List?)
            ?.map<SearchSuggested>(
              (e) => e == null
                  ? SearchSuggested.fromJson({})
                  : SearchSuggested.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /* ?.map((e) => e == null
            ? null
            : SearchSuggested.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    history:
        (json['history'] as List?)
            ?.map<SearchHistory>(
              (e) => e == null
                  ? SearchHistory.fromJson({})
                  : SearchHistory.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [],
    /*?.map(
          (e) => e == null
              ? null
              : SearchHistory.fromJson(e as Map<String, dynamic>),
        )
        ?.toList(),*/
  );
}

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'suggested': instance.suggested,
      'history': instance.history,
    };

SearchSuggested _$SearchSuggestedFromJson(Map<String, dynamic> json) {
  return SearchSuggested(
    key: json['key'] as int,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$SearchSuggestedToJson(SearchSuggested instance) =>
    <String, dynamic>{'key': instance.key, 'title': instance.title};

SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) {
  return SearchHistory(key: json['key'] as int, title: json['title'] as String);
}

Map<String, dynamic> _$SearchHistoryToJson(SearchHistory instance) =>
    <String, dynamic>{'key': instance.key, 'title': instance.title};

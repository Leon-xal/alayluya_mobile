import 'dart:async';
import 'package:dio/dio.dart';
import '../utils/global.dart';

/// 用户管理相关
class ReqArticleCate {
  final Dio _dio;

  ReqArticleCate(this._dio);

  /// 獲取列表
  Future<Response> list({int cateid = 0}) {
    return _dio.post(
      G.prdapi + '/article-cate',
      //        '/article-cate',
      queryParameters: {'p_cateid': cateid},
    );
  }

  /// 根據標題獲取文章id
  Future<Response> request_article_id_by_title({required String title}) {
    return _dio.post(
      G.prdapi + '/get-article-id',
      queryParameters: {
        'slug': title,
      },
    );
  }
}

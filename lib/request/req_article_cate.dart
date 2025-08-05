import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

/// 用户管理相关
class ReqArticleCate {
  final Dio _dio;

  ReqArticleCate(this._dio);

  /// 獲取列表
  Future<Response> list({
    int cateid = 0,
  }) {
    return _dio.post(
        G.prdapi+'/article-cate',
//        '/article-cate',
        queryParameters: {
          'p_cateid': cateid,
        }
    );
  }

}
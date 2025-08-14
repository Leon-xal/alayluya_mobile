import 'dart:async';
import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
import '../utils/global.dart';

class ReqSearch {
  final Dio _dio;

  ReqSearch(this._dio);

  Future<Response> index({int uid = 0}) {
    //    print('searchindex=====>${uid}');
    return _dio.post(
      G.prdapi + '/show-search',
      queryParameters: {'user_id': uid},
    );
  }

  Future<Response> dosearch({String? search_key, int uid = 0}) {
    //    print('dosearch=====>${uid}');
    return _dio.post(
      G.prdapi + '/do-search',
      queryParameters: {'search_key': search_key, 'user_id': uid},
    );
  }
}

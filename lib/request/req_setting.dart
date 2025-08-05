import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

class ReqSetting {
  final Dio _dio;

  ReqSetting(this._dio);

  Future<Response> getSetting({
    @required String user_version = '',
  }) {
    return _dio.post(
        G.prdapi+'/get-setting',
        queryParameters: {
          'user_version': user_version,
        }
    );
  }

}
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio _dio;
  static DioCacheManager _manager;
  static final baseUrl = "https://calzadopluis.com/admin/v1/admin/v1/";
  static final Options options = buildCacheOptions(Duration(minutes: 2),
      maxStale: Duration(days: 10), forceRefresh: true);

  static Dio getDioCached({Map headers}) {
    if (null == _dio) {
      _dio = Dio(
        BaseOptions(
            contentType: "application/json; charset=utf-8",
            connectTimeout: 5000,
            headers: headers),
      )..interceptors.add(getCacheManager().interceptor);
    }
    if (headers != null) _dio.options.headers = headers;
    return _dio;
  }

  static Dio getDio({Map headers}) {
    _dio = Dio(
      BaseOptions(
          contentType: "application/json; charset=utf-8",
          connectTimeout: 5000,
          headers: headers),
    );

    if (headers != null) _dio.options.headers = headers;
    return _dio;
  }

  static DioCacheManager getCacheManager() {
    if (null == _manager) {
      _manager = DioCacheManager(CacheConfig(baseUrl: baseUrl));
    }
    return _manager;
  }

  static Map<String, String> getPrintError(
      dynamic onError, dynamic stackTrace) {
    return {
      "Error occur": "",
      "onError": onError.toString(),
      "stackTrace": stackTrace.toString()
    };
  }

  /*Request area*/
  static Future<Response> get(
      {@required String url,
      @required bool cachedPetition,
      Map<dynamic, dynamic> headers}) async {
    if (cachedPetition) {
      return getDioCached(headers: headers).get(url, options: options);
    }
    return getDio(headers: headers).get(url, options: options);
  }

  static Future<Response> post(
      {@required String url,
      @required Map<dynamic, dynamic> data,
      @required bool cachedPetition,
      Map<dynamic, dynamic> headers}) async {
    if (cachedPetition) {
      return getDioCached(headers: headers)
          .post(url, data: jsonEncode(data), options: options);
    }
    return getDio(headers: headers)
        .post(url, data: jsonEncode(data), options: options);
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_practical_1/api/api_end_points.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: APIEndPoints.baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        String jsonString = jsonEncode(e.response!.data);
        e.response!.statusMessage = jsonString;
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  ///===== Get request =====
  Future<Response> getRequest(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    Response? response;
    try {
      response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return Response(
            requestOptions: RequestOptions(),
            statusCode: e.response!.statusCode,
            statusMessage: e.response.toString());
      } else {
        return response!;
      }
    }
  }

  ///===== Post request
  Future<Response> postRequest(String path,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    Response? response;
    try {
      response =
          await _dio.post(path, data: data, options: Options(headers: headers));

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return Response(
            requestOptions: RequestOptions(),
            statusCode: e.response!.statusCode,
            statusMessage: e.response.toString());
      } else {
        return response!;
      }
    }
  }
}

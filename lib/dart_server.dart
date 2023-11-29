import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

const String apiKey = "5a129440bf2549fcb741806b0120a29c";

class Server {
  Future<List<Map<String, dynamic>>> getData(
      String daeNum, String confDate) async {
    const String apiUrl =
        'https://open.assembly.go.kr/portal/openapi/ngytonzwavydlbbha';
    final Map<String, dynamic> params = {
      'Type': 'json',
      'KEY': apiKey,
      "DAE_NUM": daeNum,
      "CONF_DATE": confDate,
    };

    // HTTP 응답의 body에서 HTML 데이터 추출
    Dio dio = Dio();
    List<Map<String, dynamic>> meettings = [];
    try {
      final response = await dio.get(apiUrl, queryParameters: params);
      if (response.statusCode == 200) {
        // 서버로부터 데이터가 정상적으로 수신된 경우
        dynamic data = response.data;
        Map<String, dynamic> jsonMap = jsonDecode(response.data);
        var meettingData = jsonMap["ngytonzwavydlbbha"][1]['row'];
        if (meettingData != null) {
          print(meettingData);
          for (var data in meettingData) {
            meettings.add(data);
          }
        } else {
          // 서버로부터 오류 응답이 수신된 경우
          print('API 요청 실패 (GET): ${response.statusCode}');
        }
      }
    } catch (error) {
      // Dio에서 발생한 예외를 처리합니다.
      print('Dio 예외 (GET): $error');
    }
    return meettings;
  }
}

Server server = Server();

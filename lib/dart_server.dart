import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart' as pdfLib;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

const String apiKey = "5a129440bf2549fcb741806b0120a29c";

class Server {
  final String pdfUrl = 'https://example.com/sample.pdf'; // 실제 PDF URL로 변경

  Future<void> downloadAndReadPdf() async {
    // PDF 다운로드
    final http.Response response = await http.get(Uri.parse(pdfUrl));
    final Uint8List bytes = response.bodyBytes;

    // 다운로드한 PDF로부터 텍스트 추출
    // final pdfLib.PdfDocument pdfDoc = await pdfLib.PdfDocument.openData(bytes);
    // final StringBuffer textBuffer = StringBuffer();

    // for (int i = 0; i < pdfDoc.pages.length; i++) {
    //   final pdfLib.PdfPage page = pdfDoc.pages[i];
    //   final String pageText = await page.extractText();
    //   textBuffer.write(pageText);
    // }

    // final String text = textBuffer.toString();
    // print('PDF에서 추출한 텍스트:\n$text');
  }

  Future<void> getData() async {
    const String apiUrl =
        'https://open.assembly.go.kr/portal/openapi/nekcaiymatialqlxr';
    final Map<String, dynamic> params = {
      'Type': 'json',
      'KEY': apiKey,
      "UNIT_CD": "100021",
    };

    // HTTP 응답의 body에서 HTML 데이터 추출
    Dio dio = Dio();
    try {
      final response = await dio.get(apiUrl, queryParameters: params);
      if (response.statusCode == 200) {
        // 서버로부터 데이터가 정상적으로 수신된 경우
        dynamic data = response.data;
        Map<String, dynamic> jsonMap = jsonDecode(response.data);
        var ds = jsonMap["nekcaiymatialqlxr"][1]['row'];
        List<Map<String, String>> rows = [];
        if (ds != null) {
          for (var rowData in ds) {
            String meetingSession = rowData["MEETINGSESSION"];
            String cha = rowData["CHA"];
            String title = rowData["TITLE"];
            String meettingTime = rowData["MEETTING_TIME"];
            String meetingDate = rowData["MEETTING_DATE"];
            String link = rowData["LINK_URL"];
            String uniCd = rowData["UNIT_CD"];
            String uniNm = rowData["UNIT_NM"];

            String s =
                '$meetingSession  $cha  $title $meetingDate  $meettingTime  $link  $uniCd  $uniNm';
            // print(s);
            print(s);
            // rows.add(jmap);
          }
          // 데이터 처리 또는 상태 업데이트 등을 수행합니다.
        } else {
          // 서버로부터 오류 응답이 수신된 경우
          print('API 요청 실패 (GET): ${response.statusCode}');
        }
      }
    } catch (error) {
      // Dio에서 발생한 예외를 처리합니다.
      print('Dio 예외 (GET): $error');
    }
  }
}

Server server = Server();

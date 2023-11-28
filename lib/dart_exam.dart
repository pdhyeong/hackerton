import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chart Example'),
        ),
        body: const ChartWidget(),
      ),
    );
  }
}

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<DataRow> gridRows = [];

  @override
  void initState() {
    super.initState();
    getChartData();
  }

  Future<void> getChartData() async {
    final response = await http.get(
      Uri.parse(
          'https://open.assembly.go.kr/portal/openapi/ncocpgfiaoituanbr?AGE=21&BILL_NO=2106221&Type=json'),
    );

    if (response.statusCode == 200) {
      drawGrid(json.decode(response.body));
    } else {
      print('Failed to load data');
    }
  }

  void drawGrid(dynamic jsonData) {
    var data = jsonData['ncocpgfiaoituanbr'][1]['row'];

    if (data != null) {
      List<DataRow> rows = [];

      for (var rowData in data) {
        rows.add(DataRow(
          cells: [
            DataCell(Text(rowData['YES_TCNT'].toString())),
            DataCell(Text(rowData['NO_TCNT'].toString())),
            DataCell(Text(rowData['BLANK_TCNT'].toString())),
          ],
        ));
      }

      setState(() {
        gridRows = rows;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('찬성')),
            DataColumn(label: Text('반대')),
            DataColumn(label: Text('기권')),
          ],
          rows: gridRows,
        ),
      ),
    );
  }
}

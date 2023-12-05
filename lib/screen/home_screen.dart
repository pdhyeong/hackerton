import 'package:flutter/material.dart';
import 'package:hackerton/widgets/BottomNavi.dart';
import 'package:hackerton/dart_server.dart';
import 'package:hackerton/screen/MeetingDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> meetings = [];
  String selectedDaeNum = "21";
  String selectedConfDate = "2023";

  String removeDataPattern(String input) {
    // 정규식 패턴
    RegExp datePattern = RegExp(r'\(\d{4}년 \d{2}월 \d{2}일\)');

    return input.replaceAll(datePattern, "");
  }

  @override
  void initState() {
    super.initState();
    fetchData(selectedDaeNum, selectedConfDate);
  }

  void fetchData(String daeNum, String confDate) async {
    List<Map<String, dynamic>> data = await server.getData(daeNum, confDate);
    setState(() {
      meetings = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x000fffff),
        title: Image.asset(
          'images/assembly.png',
          fit: BoxFit.cover,
          width: 77,
          height: 53,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("대수 선택: "),
                  DropdownButton<String>(
                    value: selectedDaeNum,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDaeNum = newValue!;
                        fetchData(selectedDaeNum, selectedConfDate);
                      });
                    },
                    items: <String>[
                      "21",
                      "20",
                      "19",
                      "18",
                      "17",
                      "16"
                    ] // Add your DAE_NUM options here
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("년도 선택: "),
                  DropdownButton<String>(
                    value: selectedConfDate,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedConfDate = newValue!;
                        fetchData(selectedDaeNum, selectedConfDate);
                      });
                    },
                    items: <String>[
                      "2023",
                      "2022",
                      "2021",
                      "2020",
                      "2019",
                      "2018",
                      "2017",
                      "2016",
                      "2015",
                    ] // Add your CONF_DATE options here
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(removeDataPattern(
                          meetings[index]['TITLE'].toString())),
                      subtitle: Text(meetings[index]['CONF_DATE']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingDetailScreen(
                              meetingData: meetings[index],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

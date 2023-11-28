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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<Map<String, dynamic>> data = await server.getData();
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
          'assets/images/assembly.png',
          fit: BoxFit.cover,
          width: 77,
          height: 53,
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarExample(),
      body: ListView.builder(
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(meetings[index]['TITLE']),
            subtitle: Text(meetings[index]['MEETTING_DATE']),
            // 다른 필요한 정보들을 추가할 수 있습니다.
            onTap: () {
              // Navigate to the detail screen and pass the meeting data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetingDetailScreen(
                    meetingData: meetings[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

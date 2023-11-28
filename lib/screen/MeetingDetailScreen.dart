import 'package:flutter/material.dart';
import 'package:hackerton/GptService.dart';

class TextGenerationWidget extends StatefulWidget {
  const TextGenerationWidget({super.key});

  @override
  _TextGenerationWidgetState createState() => _TextGenerationWidgetState();
}

class _TextGenerationWidgetState extends State<TextGenerationWidget> {
  String _generatedText = "";
  bool _loading = false;

  Future<void> generateText() async {
    if (_loading) return; // 중복 요청 방지

    setState(() {
      _loading = true;
    });

    try {
      String prompt =
          "Please recommend only three restaurants near Seoul National University Station";

      var generatedText = await GptService.generateText(prompt);

      setState(() {
        _generatedText = generatedText;
      });
    } catch (e) {
      setState(() {
        _generatedText = "Error: $e";
      });
      print("Error: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: generateText,
            child: const Text('Generate Text'),
          ),
          const SizedBox(height: 20),
          Text(_loading ? 'Generating text...' : _generatedText),
        ],
      ),
    );
  }
}

class MeetingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> meetingData;

  const MeetingDetailScreen({super.key, required this.meetingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meetingData['TITLE']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meeting Title: ${meetingData['TITLE']}'),
            Text('Meeting Date: ${meetingData['MEETTING_DATE']}'),
            // Add other details as needed
            const TextGenerationWidget(), // Include the text generation widget here
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT-3 Text Generation'),
      ),
      body:
          const TextGenerationWidget(), // Include the text generation widget here
    );
  }
}
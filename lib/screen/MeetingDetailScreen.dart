import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../env/env.dart';

class MeetingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> meetingData;

  const MeetingDetailScreen({super.key, required this.meetingData});

  @override
  _MeetingDetailScreenState createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  bool isUploading = false;
  bool isButtonVisible = true;
  String? docId;
  bool isSummarizing = false;
  String? summary;
  TextEditingController messageController = TextEditingController();
  String? chatResponse;
  bool isSending = false; 

  String extractPdfUrl(String pdfLink) {
    return pdfLink.replaceAll('uri=', '');
  }

  Future<String?> uploadPdfAndGetDocId(String pdfUrl) async {
    const apiUrl = 'https://pdf.ai/api/v1/upload/url';
    const apiKey = Env.apiKey; // Replace with your actual API key

    try {
      setState(() {
        isUploading = true;
        isButtonVisible = false;
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'X-API-Key': apiKey},
        body: {'url': pdfUrl},
      );

      setState(() {
        isUploading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody['docId'];
      } else {
        print('Failed to upload PDF. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      setState(() {
        isUploading = false;
      });

      print('Error uploading PDF: $error');
      return null;
    }
  }

  Future<void> getSummary(String docId) async {
    const apiUrl = 'https://pdf.ai/api/v1/summary';
    const apiKey = Env.apiKey; // Replace with your actual API key

    try {
      setState(() {
        isSummarizing = true;
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'X-API-Key': apiKey},
        body: {'docId': docId, 'language': 'korean'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final summaryText = responseBody['content'];
        setState(() {
          summary = summaryText;
          isSummarizing = false;
        });
      } else {
        print('Failed to get PDF summary. Status code: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isSummarizing = false;
      });

      print('Error getting PDF summary: $error');
    }
  }

  Future<void> chatWithPdf(String docId, String message) async {
    const apiUrl = 'https://pdf.ai/api/v1/chat';
    const apiKey = Env.apiKey; // Replace with your actual API key

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'X-API-Key': apiKey},
        body: {
          'docId': docId,
          'message': message,
          'save_chat': 'true',
          'language': 'korean',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final content = responseBody['content'];
        setState(() {
          chatResponse = content;
        });
      } else {
        print('Failed to chat with PDF. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error chatting with PDF: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meetingData['TITLE']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isButtonVisible)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final pdfLink = widget.meetingData['PDF_LINK_URL'];
                    final pdfUrl = extractPdfUrl(pdfLink);
                    final uploadedDocId = await uploadPdfAndGetDocId(pdfUrl);
                    if (uploadedDocId != null) {
                      setState(() {
                        docId = uploadedDocId;
                        isButtonVisible = false;
                      });
                      await getSummary(uploadedDocId);
                    } else {
                      print('Failed to upload PDF');
                    }
                  },
                  child: const Text('요약 정보 보기'),
                ),
              ),
            if (isUploading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (isSummarizing)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (summary != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(summary!),
                  ],
                ),
              ),
            if (summary != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Chat with PDF:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your question...',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        setState(() {
                          isSending = true;
                        });

                        await chatWithPdf(docId!, message);

                        setState(() {
                          isSending = false;
                        });
                      }
                    }, // Update button text dynamically
                    style: ElevatedButton.styleFrom(
                      // Disable the button when in "waiting" state
                      foregroundColor: isSending ? Colors.white : null,
                      backgroundColor: isSending ? Colors.grey : null,
                    ),
                    child: Text(isSending ? 'Wait' : 'Send'),
                  ),
                  if (chatResponse != null)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chat Response:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(chatResponse!),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

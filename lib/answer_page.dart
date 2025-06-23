// answer_page.dart
import 'package:flutter/material.dart';

class AnswerPage extends StatelessWidget {
  final String questionTitle;
  final String answerContent;

  const AnswerPage({
    Key? key,
    required this.questionTitle,
    required this.answerContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        ),
        title: const Text(
          'Answer', // Title for the Answer page
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Overall white background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                answerContent,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5, // Line height for readability
                ),
              ),
              // You can add more content here, like related FAQs, images, etc.
              const SizedBox(height: 30.0),
              // Example: A "Was this helpful?" section
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Was this helpful?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            print('User clicked Yes');
                            // TODO: Send feedback (e.g., API call)
                          },
                          icon: const Icon(Icons.thumb_up),
                          label: const Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            print('User clicked No');
                            // TODO: Send feedback or prompt for more details
                          },
                          icon: const Icon(Icons.thumb_down),
                          label: const Text('No'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

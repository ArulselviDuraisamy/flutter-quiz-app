import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: QuizPage(), debugShowCheckedModeBanner: false));

class Question {
  final String text;
  final List<String> options;
  final int answerIndex;

  const Question(this.text, this.options, this.answerIndex);
}

// Ten questions required for the project[cite: 1, 4]
const questions = [
  Question('Which language does Flutter use?', ['Java', 'Dart', 'Swift', 'Go'], 1),
  Question('Everything in Flutter is a...', ['Widget', 'Activity', 'Page', 'Script'], 0),
  Question('Who developed Flutter?', ['Apple', 'Microsoft', 'Google', 'Facebook'], 2),
  Question('How do you update the UI in a StatefulWidget?', ['updateUI()', 'setState()', 'refresh()', 'buildUI()'], 1),
  Question('Which widget is used for a scrollable list?', ['ListView', 'Column', 'Row', 'Stack'], 0),
  Question('What command is used to create a new Flutter project?', ['flutter start', 'flutter new', 'flutter init', 'flutter create'], 3),
  Question('Which widget allows layout flexibility?', ['Expanded', 'Container', 'Padding', 'SizedBox'], 0),
  Question('What is used to align items horizontally?', ['Column', 'Row', 'Stack', 'Wrap'], 1),
  Question('How do you add spacing between widgets?', ['MarginBox', 'SizedBox', 'SpaceWidget', 'GapBox'], 1),
  Question('Which file manages Flutter dependencies?', ['pubspec.yaml', 'package.json', 'build.gradle', 'flutter.xml'], 0),
];

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int? selected; // Using int? for an unset selection

  void choose(int i) {
    // Prevent double scoring by ignoring taps once answered
    if (selected != null) return;
    setState(() {
      selected = i;
      if (i == questions[index].answerIndex) {
        score++;
      }
    });
  }

  void next() => setState(() {
        index++;
        selected = null;
      });

  // Restart resets everything
  void restart() => setState(() {
        index = 0;
        score = 0;
        selected = null;
      });

  @override
  Widget build(BuildContext context) {
    // Show results screen if all questions are answered[cite: 3]
    if (index >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: $score / ${questions.length}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: restart,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[index];
    return Scaffold(
      appBar: AppBar(title: Text('Question ${index + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: index / questions.length),
            const SizedBox(height: 16),
            Text(q.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            for (var i = 0; i < q.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(q.options[i]),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Feedback shows correct and wrong answers
                  tileColor: selected == null
                      ? null
                      : i == q.answerIndex
                          ? Colors.green.shade100
                          : i == selected
                              ? Colors.red.shade100
                              : null,
                  onTap: () => choose(i),
                ),
              ),
            const Spacer(),
            if (selected != null)
              ElevatedButton(
                onPressed: next,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }
}

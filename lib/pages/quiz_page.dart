import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz/components/result/quiz_card_res.dart';
import 'package:quiz/components/result/true_false_res.dart';
import 'package:quiz/components/test/open_ended.dart';
import 'package:quiz/components/test/quiz_card.dart';
import 'package:quiz/components/test/true_false.dart';
import 'package:quiz/models/models.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CheckBox());
  }
}

class CheckBox extends StatefulWidget {
  CheckBox({super.key});

  final List<Question> _questions = [
    Question(
        title: 'What is the largest living species of fish?',
        options: [
          'Whale Shark',
          'Great White Shark',
          'Manta Ray',
          'Blue Whale'
        ],
        correctAnswer: 'Whale Shark',
        type: 'mcq'),
    Question(
        title: 'Which animal is known as the "king of the sea"?',
        options: ['Dolphin', 'Killer Whale (Orca)', 'Blue Whale', 'Sea Turtle'],
        correctAnswer: 'Killer Whale (Orca)',
        type: 'mcq'),
    Question(
        title: 'How many hearts does an octopus have?',
        options: ['1', '2', '3', '4'],
        correctAnswer: '3',
        type: 'mcq'),
    Question(
        title: 'What is the largest species of turtle?',
        options: [
          'Loggerhead Turtle',
          'Leatherback Turtle',
          'Green Sea Turtle',
          'Hawksbill Turtle'
        ],
        correctAnswer: 'Leatherback Turtle',
        type: 'mcq'),
    Question(
        title:
            'Which marine creature is known for its ability to change color to match its surroundings?',
        options: ['Cuttlefish', 'Clownfish', 'Anglerfish', 'Lionfish'],
        correctAnswer: 'Cuttlefish',
        type: 'mcq'),
    Question(
        title: 'What is the SI unit of electric charge?',
        options: ['Coulomb', 'Ampere', 'Volt', 'Watt'],
        correctAnswer: 'Coulomb',
        type: 'mcq'),
    Question(
        title: 'What is the formula for calculating momentum?',
        options: [
          'Force × Distance',
          'Mass × Velocity',
          'Energy ÷ Time',
          'Acceleration × Time'
        ],
        correctAnswer: 'Mass × Velocity',
        type: 'mcq'),
    Question(
        title: 'Which scientist is known for the theory of relativity?',
        options: [
          'Isaac Newton',
          'Albert Einstein',
          'Galileo Galilei',
          'Nikola Tesla'
        ],
        correctAnswer: 'Albert Einstein',
        type: 'mcq'),
    Question(
        title:
            '9.81 m/s² is the acceleration due to gravity on the surface of the Earth (approximately)?',
        options: [
          'true',
          'false',
        ],
        correctAnswer: 'false',
        type: 'tf'),
    Question(
        title:
            'What is the principle that states that the total electric charge in a closed system is constant?',
        options: [],
        correctAnswer: 'Conservation of Charge',
        type: 'oe'),
  ];

  // List<Answer> _answers = [];

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _showDivider = false;
  bool _isSubmit = false;

  Map<String, Object?> selectedAnswers = {};
  final List<Answer> _results = [];

  final ScrollController _scrollController = ScrollController();
  bool _showSubmissionActions = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    debugPrint('Scroll Controller: ${_scrollController.position}');
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showSubmissionActions = true;
      });
    } else {
      setState(() {
        _showSubmissionActions = false;
      });
    }
  }

  void _handleSelectedAnswer(Answer answer) {
    // if answer exists than find it and replace it with the new option index
    setState(() {
      if (answer.selectedOption != null) {
        selectedAnswers[answer.questionTitle] = answer.selectedOption;
        _results.add(answer);
      } else {
        selectedAnswers[answer.questionTitle] = answer.openEndedAnswer;
        _results.add(answer);
        if (_results.last.questionTitle == answer.questionTitle) {
          debugPrint('Skipping Duplicate');
        } else {
          _results.add(answer);
        }
      }
    });
    debugPrint(
        'Question Title: ${answer.questionTitle}\nSelected option index: ${answer.selectedOption}\n');
  }

  void openEndedAnswer(String questionTitle, String openEndedAns) {
    debugPrint('title: $questionTitle\nanswer: $openEndedAns');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // show result when answers are submitted
            if (_isSubmit == true)
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: widget._questions.length,
                itemBuilder: (context, index) {
                  Answer results = _results[index];
                  return results.type == 'tf'
                      ? TrueFalseRes(
                          questionTitle: results.questionTitle,
                          point: 1,
                          index: index + 1,
                          selectedIndex: selectedAnswers[results.questionTitle],
                          options: results.options,
                          onAnswerSelected: _handleSelectedAnswer,
                          correctIndexOf: results.isCorrect,
                          type: results.type,
                        )
                      : results.type == 'oe'
                          ? OpenEnded(
                              questionTitle: results.questionTitle,
                              point: 1,
                              index: index + 1,
                              selectedIndex:
                                  selectedAnswers[results.questionTitle],
                              options: results.options,
                              onAnswerSelected: _handleSelectedAnswer,
                              type: results.type,
                              selectedAnswersmap: selectedAnswers,
                            )
                          : QuizCardRes(
                              questionTitle: results.questionTitle,
                              point: 1,
                              index: index + 1,
                              selectedIndex:
                                  selectedAnswers[results.questionTitle],
                              options: results.options,
                              onAnswerSelected: _handleSelectedAnswer,
                              correctIndexOf: results.isCorrect,
                              type: results.type,
                            );
                },
              )
            // Show Questions if the submit button is not clicked
            else
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                // controller: _scrollController,
                itemCount: widget._questions.length,
                itemBuilder: (context, index) {
                  Question question = widget._questions[index];
                  return question.type == 'tf'
                      ? TrueFalse(
                          questionTitle: question.title,
                          point: 1,
                          index: index + 1,
                          selectedIndex: selectedAnswers[question.title],
                          isCorrect: question.correctAnswer,
                          options: question.options,
                          onAnswerSelected: _handleSelectedAnswer,
                          type: question.type,
                        )
                      : question.type == 'oe'
                          ? OpenEnded(
                              questionTitle: question.title,
                              point: 1,
                              index: index + 1,
                              selectedIndex: selectedAnswers[question.title],
                              options: question.options,
                              onAnswerSelected: _handleSelectedAnswer,
                              type: question.type,
                              selectedAnswersmap: selectedAnswers,
                            )
                          : QuizCard(
                              questionTitle: question.title,
                              point: 1,
                              index: index + 1,
                              selectedIndex: selectedAnswers[question.title],
                              isCorrect: question.correctAnswer,
                              options: question.options,
                              onAnswerSelected: _handleSelectedAnswer,
                              type: question.type,
                            );
                },
              ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                    height: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                            side: const BorderSide(color: Colors.black12),
                          ),
                        ),
                        onPressed: () {
                          debugPrint("Hello");
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Color(0xFF7F56D9),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F56D9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          String json =
                              jsonEncode('results length:${_results.last}');

                          debugPrint(json);

                          setState(() {
                            _isSubmit = !_isSubmit;
                          });
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

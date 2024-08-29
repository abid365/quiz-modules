import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz/components/test/multi_question.dart';
import 'package:quiz/components/test/title_and_desc.dart';
import 'package:quiz/components/toast/universal_toast.dart';
import 'package:quiz/models/models.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final List<String> _qlist = [
    'Title&Description',
    'Create Question',
  ];

  bool _isSubmit = false;

  List<String> questionTypes = ['Open Ended', 'True False', 'Multiple Choice'];
  Map<String, String> titleAndDescription = {};

  Map<String, int> selectedAnswers = {};
  final List<File> _selectedImages = [];
  Map<String, File> experimentImages = {};
  List<ApiResCreateQuestion> createdQuestionJSON = [];
  bool isAutomaticGrading = false;

  String title = '';
  String description = '';

  /// Scroll Controller
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

  void _handleAddQuestion() {
    setState(() {
      _qlist.add('Create Question');
    });
    debugPrint('Inside Add Question');
  }

  void _handleSelectedOption(CreateQuestion question) {
    setState(() {
      if (question.correctAnswer != null) {
        selectedAnswers[question.qIndex] = question.correctAnswer!;
      }
    });

    // debugPrint("Selected Option[in page]: ${question.correctAnswer}");
    debugPrint('$selectedAnswers');
  }

  void _handleDeleteQuestion(int index) {
    debugPrint('$index');
    setState(() {
      /// remove selected answer from selectedAnswr map
      final qIndex = _qlist[index];
      _qlist.remove(qIndex);
      if (selectedAnswers['Question$index'] == null) {
        debugPrint('Selected answer not found, skipping delete');
      } else {
        selectedAnswers.remove('Question$index');
      }

      if (experimentImages['Question$index'] == null) {
        debugPrint('Image not found, skipping delete');
      } else {
        experimentImages.remove('Question$index');
        createdQuestionJSON[index - 1].image = File('');
      }

      /// check and delete question from createdQuestionJSON
      debugPrint('Index is: $index');
      if (createdQuestionJSON.length < index) {
        debugPrint('Question not found, skipping delete');
      } else {
        debugPrint('Inside ApiResCreateQuestion');
        ApiResCreateQuestion removeQuestion = createdQuestionJSON[index - 1];
        createdQuestionJSON.remove(removeQuestion);
      }
    });
  }

  void _handleCreateQuestion(ApiResCreateQuestion createQuestion, int qindex) {
    bool isDuplicate = createdQuestionJSON
        .any((p) => p.question_title == createQuestion.question_title);

    if (isDuplicate) {
      debugPrint('Duplicate found, skipping...');
      return;
    }
    debugPrint('Added to the list');
    setState(() {
      createdQuestionJSON.add(createQuestion);
    });
  }

  void _handleAddLastQuestion(ApiResCreateQuestion createQuestion, int qindex) {
    createdQuestionJSON.add(createQuestion);
  }

  void printTitleAndDescription() {
    debugPrint('$titleAndDescription');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._qlist.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;

                if (item == 'Title&Description') {
                  return Column(
                    children: [
                      TitleAndDesc(
                        titleAndDesc: titleAndDescription,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: isAutomaticGrading,
                                onChanged: (value) {
                                  setState(() {
                                    isAutomaticGrading = value;
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                "Automatic Grading",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  print(index);

                  return MultiQuestion(
                    key: UniqueKey(),
                    handleAddLastQuestion: () {},
                    handleAddQuestion: _handleAddQuestion,
                    handleDeleteQuestion: _handleDeleteQuestion,
                    handleSelectedOption: _handleSelectedOption,
                    handleCreateQuestion: _handleCreateQuestion,
                    createQuestionJson: createdQuestionJSON,
                    index: index,
                    images: _selectedImages,
                    experimentImagesMap: experimentImages,
                    templateLength: _qlist.length,
                    selectedAnswersMap: selectedAnswers,
                    isAutoGradingOn: isAutomaticGrading,
                  );
                }
              }).toList(),

              // Adding the widgets after the list
              const Divider(
                thickness: 1.0,
                color: Colors.grey,
                height: 20,
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
                      onPressed: () {},
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Color(0xFF7F56D9),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F56D9),
                        // backgroundColor: _isSubmitting
                        //     ? Colors.grey
                        //     : const Color(0xFF7F56D9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: () {
                        debugPrint('$createdQuestionJSON');
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

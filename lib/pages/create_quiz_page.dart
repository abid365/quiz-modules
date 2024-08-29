import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz/components/test/multi_question.dart';
import 'package:quiz/components/test/title_and_desc.dart';
import 'package:quiz/models/models.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final List<String> _qlist = ['Title&Description', 'Create Question'];

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

    debugPrint('$selectedAnswers');
  }

  void _handleDeleteQuestion(int index) {
    debugPrint('$index');
    setState(() {
      final qIndex = _qlist[index];
      _qlist.remove(qIndex);
      if (_qlist.length == index) {
        selectedAnswers.remove('Question$index');
        experimentImages.remove('Question$index');
      } else {
        selectedAnswers.remove('Question$index');
        experimentImages.remove('Question$index');
        Map<String, int> selectedAnswersUpdate = Map.fromEntries(
          selectedAnswers.entries.toList().asMap().entries.map((indexedEntry) {
            int index = indexedEntry.key;
            MapEntry<String, int> entry = indexedEntry.value;
            String newKey =
                'Question${index + 1}'; // Add 1 if you want to start from 1
            return MapEntry(newKey, entry.value);
          }),
        );
        selectedAnswers = selectedAnswersUpdate;
        Map<String, File> experimentImagesUpdate = Map.fromEntries(
            experimentImages.entries
                .toList()
                .asMap()
                .entries
                .map((indexedEntry) {
          int index = indexedEntry.key;
          MapEntry<String, File> entry = indexedEntry.value;
          String newKey = 'Question${index + 1}';
          return MapEntry(newKey, entry.value);
        }));
        experimentImages = experimentImagesUpdate;
      }

      if (createdQuestionJSON.length >= index) {
        createdQuestionJSON.removeAt(index - 1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.only(top: 30.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Test",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Add necessary information to create new test.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                          child: Divider(
                            thickness: 1.0,
                            color: Color.fromARGB(48, 158, 158, 158),
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _qlist.length,
                itemBuilder: (context, index) {
                  return _qlist[index] == 'Title&Description'
                      ? Column(
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : MultiQuestion(
                          key: ValueKey(_qlist[index]),
                          handleAddQuestion: _handleAddQuestion,
                          handleDeleteQuestion: _handleDeleteQuestion,
                          handleSelectedOption: _handleSelectedOption,
                          handleCreateQuestion: _handleCreateQuestion,
                          handleAddLastQuestion: _handleAddLastQuestion,
                          createQuestionJson: createdQuestionJSON,
                          index: index,
                          images: _selectedImages,
                          experimentImagesMap: experimentImages,
                          templateLength: _qlist.length,
                          selectedAnswersMap: selectedAnswers,
                          isAutoGradingOn: isAutomaticGrading,
                        );
                },
              ),
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
                        debugPrint('JSON: $createdQuestionJSON\n');
                        debugPrint('Selected images: $experimentImages\n');
                        debugPrint('Selected Answers: $selectedAnswers');
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

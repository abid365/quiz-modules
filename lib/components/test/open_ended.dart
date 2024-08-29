import 'package:flutter/material.dart';
import 'package:quiz/models/models.dart';

class OpenEnded extends StatefulWidget {
  final String questionTitle;
  final int point;
  final int index;
  final Object? selectedIndex;
  final List<String> options;
  final Function onAnswerSelected;
  final String? type;
  final Map<String, Object?> selectedAnswersmap;

  const OpenEnded({
    required this.questionTitle,
    required this.point,
    required this.index,
    this.selectedIndex,
    required this.options,
    required this.onAnswerSelected,
    required this.type,
    required this.selectedAnswersmap,
    super.key,
  });

  @override
  State<OpenEnded> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<OpenEnded> {
  final TextEditingController _openEndedAnswer = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _openEndedAnswer.text =
        widget.selectedAnswersmap['Question${widget.index}']?.toString() ?? '';

    // Add listener to FocusNode to detect when focus is lost
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _updateAnswer(
            _openEndedAnswer.text); // Trigger update when focus is lost
      }
    });
  }

  @override
  void dispose() {
    _openEndedAnswer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateAnswer(String answer) {
    widget.onAnswerSelected(Answer(
      questionTitle: widget.questionTitle,
      openEndedAnswer: answer,
      options: [],
      isCorrect: '',
      type: widget.type,
    ));
    debugPrint(
        'title:${widget.questionTitle}\nanswer:${_openEndedAnswer.text}');

    setState(() {
      widget.selectedAnswersmap['Question${widget.index}'] = answer;
    });
  }

  void clearSelections() {
    setState(() {
      _openEndedAnswer.clear();
      widget.selectedAnswersmap.remove('Question${widget.index}');
      widget.onAnswerSelected(Answer(
        questionTitle: widget.questionTitle,
        openEndedAnswer: '',
        options: [],
        isCorrect: "",
        type: widget.type,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        _updateAnswer(_openEndedAnswer.text);
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(255, 249, 250, 251),
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 40, 10, 0),
                    child: Text(
                      "Question ${widget.index}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.5, 40, 0, 0),
                    child: Text("(${widget.point} point)"),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Text(
                  widget.questionTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.fromLTRB(40, 5, 40, 10),
                child: TextField(
                  controller: _openEndedAnswer,
                  focusNode: _focusNode, // Attach the FocusNode
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    hintText: 'Enter your answer here',
                  ),
                  onChanged: (value) {
                    _updateAnswer(value); // Optionally update in real-time
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 0, 25),
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo,
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: clearSelections,
                      child: const Text("Clear Answer"),
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

import 'package:flutter/material.dart';
import 'package:quiz/models/models.dart';

class RadioTextField extends StatefulWidget {
  final double width;
  final int radioIndex;
  // final Object? selectedCorrectAnswer;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final Function handleSelectedOption;
  final int? qIndex;
  final bool trueOrFalse;
  final Map selectedAnswersMap;

  List<ApiResCreateQuestion> createQuestionjson;

  RadioTextField(
      {required this.width,
      // this.selectedCorrectAnswer,
      required this.validator,
      required this.onSaved,
      required this.radioIndex,
      required this.handleSelectedOption,
      required this.qIndex,
      required this.createQuestionjson,
      required this.trueOrFalse,
      required this.selectedAnswersMap,
      // required this.onChanged,

      // required this.controller,
      // required this.focusNode,
      super.key});

  @override
  State<RadioTextField> createState() => _RadioTextFieldState();
}

class _RadioTextFieldState extends State<RadioTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Visibility(
        visible: widget.trueOrFalse == true ? false : true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 30, 0, 10),
          child: Row(
            children: [
              Text(
                "Option ${widget.radioIndex}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      Row(
        children: [
          Radio(
            value: widget.radioIndex,
            groupValue: widget.selectedAnswersMap["Question${widget.qIndex}"],
            onChanged: (value) {
              // debugPrint("Selected Ans Props: ${widget.selectedCorrectAnswer}");
              setState(
                () {
                  widget.handleSelectedOption(
                    CreateQuestion(
                        qIndex: "Question${widget.qIndex}",
                        correctAnswer: widget.radioIndex),
                  );

                  if (widget.createQuestionjson.isEmpty) {
                    return;
                  }
                  widget.createQuestionjson[widget.qIndex! - 1].correct_option =
                      widget.radioIndex;

                  debugPrint("Selected Option[in component]: $value");
                  debugPrint('Radio Index is: ${widget.radioIndex}');
                },
              );
            },
          ),
          SizedBox(
            width: widget.width - 50,
            height: 50,
            child: widget.trueOrFalse == true
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Text(
                      widget.radioIndex == 1 ? "True" : "False",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  )
                : TextFormField(
                    maxLines: 1,
                    initialValue: widget.createQuestionjson.isNotEmpty &&
                            widget.createQuestionjson.length >
                                widget.qIndex! - 1 &&
                            widget.createQuestionjson[widget.qIndex! - 1]
                                .question_title.isNotEmpty
                        ? widget.createQuestionjson[widget.qIndex! - 1]
                            .option[widget.radioIndex - 1]
                        : '',
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(127, 158, 158, 158),
                              width: 1.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(127, 158, 158, 158),
                              width: 1.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(127, 158, 158, 158),
                              width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(127, 158, 158, 158),
                              width: 1.0),
                        ),
                        errorStyle: const TextStyle(color: Colors.indigo),
                        hintText: 'Enter option ${widget.radioIndex}...'),
                    validator: widget.validator,
                    onSaved: widget.onSaved,
                    onChanged: (value) {
                      if (widget.trueOrFalse == true) return;
                      debugPrint(
                          'Value: $value\nRadio Text Index: ${widget.radioIndex}\nQIndex: ${widget.qIndex}');
                      if (widget.createQuestionjson.isNotEmpty) {
                        setState(() {
                          widget.createQuestionjson[widget.qIndex! - 1]
                              .option[widget.radioIndex - 1] = value;
                        });
                      }
                    },
                  ),
          ),
        ],
      ),
    ]);
  }
}

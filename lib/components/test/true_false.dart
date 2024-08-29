import 'package:flutter/material.dart';
import 'package:quiz/models/models.dart';

class TrueFalse extends StatefulWidget {
  final String questionTitle;
  final int point;
  final int index;
  final Object? selectedIndex;
  final Object? correctIndex;
  final String isCorrect;
  final List<String> options;
  final Function onAnswerSelected;
  final String? type;

  const TrueFalse({
    required this.questionTitle,
    required this.point,
    required this.index,
    this.selectedIndex,
    this.correctIndex,
    required this.isCorrect,
    required this.options,
    required this.onAnswerSelected,
    required this.type,
    super.key,
  });

  @override
  State<TrueFalse> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<TrueFalse> {
  int? selectedOptionIndex;

  void clearSelections(question, ansIndex) {
    if (widget.selectedIndex != null) {
      widget.onAnswerSelected(Answer(
          questionTitle: question,
          selectedOption: null,
          isCorrect: "",
          options: [],
          type: ""));
      // _savedIndex[widget.selectedIndex!] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Text(
                      widget.questionTitle,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      // checkColor: Colors.white,
                      // activeColor: Colors.purple[500],
                      // shape: const CircleBorder(),
                      value: index,
                      groupValue: widget.selectedIndex,
                      onChanged: (value) {
                        setState(
                          () {
                            // if (value == true) {
                            widget.onAnswerSelected(
                              Answer(
                                  questionTitle: widget.questionTitle,
                                  selectedOption: index,
                                  options: widget.options,
                                  isCorrect: widget.isCorrect,
                                  type: widget.type),
                            );

                            // }
                          },
                        );
                      },
                    ),
                    Text(
                      widget.options[index],
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            // Options

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 0, 25),
              child: Row(
                children: [
                  if (widget.selectedIndex != null)
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text("Clear Selection"),
                      onPressed: () {
                        setState(() {
                          clearSelections(
                              widget.questionTitle, widget.selectedIndex);
                        });
                      },
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

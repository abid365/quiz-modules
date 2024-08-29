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

  const OpenEnded({
    required this.questionTitle,
    required this.point,
    required this.index,
    this.selectedIndex,
    required this.options,
    required this.onAnswerSelected,
    required this.type,
    super.key,
  });

  @override
  State<OpenEnded> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<OpenEnded> {
  int? selectedOptionIndex;

  final TextEditingController _openEndedAnswer = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();
  //   _focusNode.addListener(() {
  //     if (_focusNode.hasFocus) {
  //       debugPrint('TextField is in focus');
  //       debugPrint('TextField value: ${_openEndedAnswer.text}');
  //     }
  //   });
  // }

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
  void dispose() {
    _openEndedAnswer.dispose();
    // _focusNode.dispose();
    super.dispose();
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

            Container(
              margin: const EdgeInsets.fromLTRB(40, 5, 40, 10),
              child: SizedBox(
                height: 200,
                child: TextField(
                  controller: _openEndedAnswer,
                  focusNode: _focusNode,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    hintText: 'Enter a search term',
                  ),
                  onChanged: (text) {
                    debugPrint('Text Field: $text');
                    Answer(
                      questionTitle: widget.questionTitle,
                      openEndedAnswer: text,
                      options: [],
                      isCorrect: '',
                      type: widget.type,
                    );
                  },
                ),
              ),
            ),

            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
            //       child: TextFormField(
            //         minLines: 6,
            //         maxLines: 12,
            //         keyboardType: TextInputType.multiline,
            //         decoration: const InputDecoration(
            //           alignLabelWithHint: true,
            //           border: OutlineInputBorder(),
            //           fillColor: Colors.blue,
            //           labelText: 'Enter text',
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 5,
            //     ),
            //   ],
            // ),
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

import 'package:flutter/material.dart';

class QuizCardRes extends StatefulWidget {
  final String questionTitle;
  final int point;
  final int index;
  final Object? selectedIndex;
  final String correctIndexOf;
  // final String isCorrect;
  final List<String> options;
  final Function onAnswerSelected;
  final String? type;

  const QuizCardRes({
    required this.questionTitle,
    required this.point,
    required this.index,
    this.selectedIndex,
    required this.correctIndexOf,
    // required this.isCorrect,
    required this.options,
    required this.onAnswerSelected,
    required this.type,
    super.key,
  });

  @override
  State<QuizCardRes> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCardRes> {
  int? isCorrect(int optionIndex) {
    if (widget.options.indexOf(widget.correctIndexOf) == optionIndex) {
      return optionIndex;
    } else {
      return null;
    }
  }

  int? isSelected(int optionIndex) {
    if (widget.selectedIndex == optionIndex) {
      return optionIndex;
    } else {
      return null;
    }
  }

  int? checkOption(int optionIndex) {
    if (isSelected(optionIndex) != null) {
      return isSelected(optionIndex);
    } else if (isCorrect(optionIndex) != null) {
      return isCorrect(optionIndex);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(105, 235, 239, 244),
        ),
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 10, 10),
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
              itemCount: widget.options.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      value: index,
                      groupValue: checkOption(index),
                      activeColor:
                          isCorrect(index) != null ? Colors.green : Colors.red,
                      onChanged: (value) {},
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.selectedIndex != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 25, 20),
                      child: SizedBox(
                        // width: 200,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                widget.options.indexOf(widget.correctIndexOf) ==
                                        widget.selectedIndex
                                    ? const Color.fromARGB(54, 196, 115, 210)
                                    : const Color.fromARGB(67, 197, 132, 127),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: BorderSide(
                                width: 0.5,
                                color: widget.options
                                            .indexOf(widget.correctIndexOf) ==
                                        widget.selectedIndex
                                    ? Colors.purple
                                    : const Color.fromARGB(255, 202, 94, 86),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            widget.options.indexOf(widget.correctIndexOf) ==
                                    widget.selectedIndex
                                ? "Points obtained: ${widget.point}"
                                : "Points obtained: 0",
                            style: TextStyle(
                                color: widget.options
                                            .indexOf(widget.correctIndexOf) ==
                                        widget.selectedIndex
                                    ? const Color(0xFF7F56D9)
                                    : Colors.red[500],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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

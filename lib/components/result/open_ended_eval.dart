import 'package:flutter/material.dart';
// import 'package:frontend_mobile/components/toast/confrim_toast.dart';

class OpenEndedEval extends StatefulWidget {
  final String questionTitle;
  final int point;
  final int index;
  final String? questionId;
  final String? imageUrl;
  final String? type;
  final String? openEndedAnswer;
  // Map<String, dynamic> marks;

  OpenEndedEval(
      {required this.questionTitle,
      required this.point,
      required this.index,
      required this.questionId,
      required this.imageUrl,
      required this.type,
      required this.openEndedAnswer,
      // required this.marks,
      super.key});

  @override
  State<OpenEndedEval> createState() => _OpenEndedEvalState();
}

class _OpenEndedEvalState extends State<OpenEndedEval> {
  final TextEditingController _openEndedAnswer = TextEditingController();

  @override
  void dispose() {
    _openEndedAnswer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 249, 250, 251),
      ),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
          const SizedBox(height: 10),
          Visibility(
            visible: widget.imageUrl!.isEmpty ? false : true,
            child: SizedBox(
              height: 250.0,
              width: 280.0,
              child: Image.network(
                widget.imageUrl!,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: const SizedBox(
                      height: 250.0,
                      width: 280.0,
                      child: Center(
                        child: Icon(
                          Icons.phonelink_erase_rounded,
                          size: 50,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.questionTitle,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )),
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.fromLTRB(40, 5, 40, 40),
              child: Column(
                children: [
                  const Row(children: [
                    Text(
                      'Answer',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.openEndedAnswer!.trim(),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          return;
                          // ignore: dead_code
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(162, 51, 48, 48),
                                      width: 1.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 12, 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Provide Marks',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _openEndedAnswer,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 2.0),
                                          ),
                                          hintText: 'Provide Marks',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF7F56D9),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: const Text(
                                              'Clear',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF7F56D9),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (int.parse(
                                                        _openEndedAnswer.text) >
                                                    widget.point) {
                                                  return;
                                                }
                                                // widget.marks[
                                                //         "${widget.questionId}"] =
                                                //     int.parse(
                                                //         _openEndedAnswer.text);
                                              });
                                              debugPrint(
                                                  'QID: ${_openEndedAnswer.text}');
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF6941C6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ), // Button border color
                        ),
                        child: const Text(
                          "...",
                          style: const TextStyle(
                              color: Color(0xFF6941C6)), // Button text color
                        ),
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}

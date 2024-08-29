import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz/components/input/custom_form_field_with_label.dart';
import 'package:quiz/components/test/radio_text_field.dart';
import 'package:quiz/components/toast/universal_toast.dart';
import 'package:quiz/models/models.dart';
import 'package:quiz/utils/extension.dart';

List<String> questionTypes = ['Open Ended', 'True False', 'Multiple Choice'];
List<String> autoGradQuestionTypes = ['True False', 'Multiple Choice'];

class MultiQuestion extends StatefulWidget {
  final Function handleAddQuestion;
  final Function handleDeleteQuestion;
  final Function handleSelectedOption;
  final Function handleCreateQuestion;
  final Function handleAddLastQuestion;
  Map selectedAnswersMap;
  bool isAutoGradingOn;
  // final Object? selectedAnswer;
  final int index;
  final List<File> images;
  final Map<String, File> experimentImagesMap;
  final int templateLength;
  List<ApiResCreateQuestion> createQuestionJson;
  MultiQuestion(
      {required this.handleAddQuestion,
      required this.handleDeleteQuestion,
      required this.index,
      required this.images,
      required this.experimentImagesMap,
      required this.templateLength,
      // this.selectedAnswer,
      required this.handleSelectedOption,
      required this.handleCreateQuestion,
      required this.handleAddLastQuestion,
      required this.selectedAnswersMap,
      required this.isAutoGradingOn,
      required this.createQuestionJson,
      super.key});

  @override
  State<MultiQuestion> createState() => _MultiQuestionState();
}

class _MultiQuestionState extends State<MultiQuestion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String title, points;
  final List<String> options = [];

  late bool autoGrad;

  @override
  void initState() {
    super.initState();
    autoGrad = widget.isAutoGradingOn;
  }

  String dropdownValue = questionTypes.last;

  // text field cursor focus
  // Separate text field controllers and focus nodes

  final FocusNode _pointsFocusNode = FocusNode();
  final FocusNode _questionTitleFocusNode = FocusNode();

  Future _pickImageFromGallery(index) async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage == null) return;
      final imageUploaded = File(returnedImage.path);
      setState(() {
        // widget.images.add(imageUploaded);
        widget.experimentImagesMap['Question$index'] = imageUploaded;
        if (widget.createQuestionJson.isEmpty ||
            widget.createQuestionJson.length < index) {
          return;
        } else {
          widget.createQuestionJson[index - 1].image = imageUploaded;
        }
      });
      debugPrint('${widget.images}');
    } catch (error) {
      debugPrint('error in future:$error');
    }
  }

  void handleDeleteImage(index) {
    setState(() {
      widget.experimentImagesMap.remove('Question$index');
      if (widget.createQuestionJson.isEmpty ||
          widget.createQuestionJson.length < index) {
        return;
      } else {
        widget.createQuestionJson[index - 1].image = File('');
      }
    });
  }

  /// handle question type state
  String handleTypes(index) {
    if (widget.createQuestionJson.isNotEmpty &&
        widget.createQuestionJson.length >= index) {
      return dropdownValue = widget.createQuestionJson[index - 1].type;
    }
    return questionTypes.last;
  }

  @override
  void dispose() {
    /// Dispose all controllers and focus nodes

    _pointsFocusNode.dispose();
    _questionTitleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _pointsFocusNode.unfocus();
        _questionTitleFocusNode.unfocus();
      },
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(51, 212, 212, 201),
          ),
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 120),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${widget.index}*",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                      visible: widget.index == 1 ? false : true,
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          widget.index == 1
                              ? null
                              : widget.handleDeleteQuestion(widget.index);
                        },
                        icon: const Icon(Icons.cancel),
                        color: const Color.fromARGB(132, 242, 62, 62),
                        focusColor: const Color.fromARGB(204, 223, 112, 104),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth,
                          child: DropdownMenu(
                            width: constraints.maxWidth,
                            inputDecorationTheme: InputDecorationTheme(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(127, 158, 158, 158),
                                      width: 1.0)),
                            ),
                            initialSelection: handleTypes(widget.index),
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            dropdownMenuEntries: widget.isAutoGradingOn == true
                                ? autoGradQuestionTypes
                                    .map<DropdownMenuEntry<String>>(
                                    (String value) {
                                      return DropdownMenuEntry(
                                          value: value, label: value);
                                    },
                                  ).toList()
                                : questionTypes.map<DropdownMenuEntry<String>>(
                                    (String value) {
                                      return DropdownMenuEntry(
                                          value: value, label: value);
                                    },
                                  ).toList(),
                          ),
                        )
                      ],
                    );
                  },
                ),
                CustomFormFieldWithLabel(
                  labelText: "Points",
                  focusNode: _pointsFocusNode,
                  initalValue: widget.createQuestionJson.isNotEmpty &&
                          widget.createQuestionJson.length > widget.index - 1 &&
                          widget.createQuestionJson[widget.index - 1]
                              .question_title.isNotEmpty
                      ? widget.createQuestionJson[widget.index - 1].points
                      : '',
                  validator: (val) {
                    if (!val!.isValidPoints) {
                      return 'Enter a valid point';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    points = val!;
                  },
                  onChanged: (val) {
                    if (widget.createQuestionJson.isEmpty) {
                      return;
                    }
                    setState(() {
                      widget.createQuestionJson[widget.index - 1].points = val!;
                    });
                  },
                ),
                CustomFormFieldWithLabel(
                  labelText: "Question Title",
                  focusNode: _questionTitleFocusNode,
                  initalValue: widget.createQuestionJson.isNotEmpty &&
                          widget.createQuestionJson.length > widget.index - 1 &&
                          widget.createQuestionJson[widget.index - 1]
                              .question_title.isNotEmpty
                      ? widget
                          .createQuestionJson[widget.index - 1].question_title
                      : '',
                  hintText: "Enter question title",
                  validator: (val) {
                    if (!val!.isValidTitle) {
                      return 'Question title is required';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val!;
                  },
                  onChanged: (val) {
                    if (widget.createQuestionJson.isEmpty) {
                      return;
                    }
                    setState(() {
                      widget.createQuestionJson[widget.index - 1]
                          .question_title = val!;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                // if (widget.index > 0 && widget.index <= widget.images.length)
                //   Image.file(
                //     widget.images[widget.index - 1],
                //     fit: BoxFit.contain,
                //   )
                // else
                //   Container(
                //     height: 150,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(14),
                //       color: const Color.fromARGB(139, 249, 250, 251),
                //       border: Border.all(
                //         color: const Color.fromARGB(
                //             107, 158, 158, 158), // Border color
                //         width: 1, // Border width
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.only(top: 20),
                //               child: IconButton(
                //                 iconSize: 40,
                //                 onPressed: () {
                //                   _pickImageFromGallery(widget.index);
                //                 },
                //                 icon: const Icon(
                //                     Icons.drive_folder_upload_rounded),
                //                 color: const Color.fromARGB(249, 60, 55, 55),
                //                 focusColor:
                //                     const Color.fromARGB(204, 223, 112, 104),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               "Click to upload ",
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Color(0xFF7F56D9),
                //               ),
                //             ),
                //             Text("or drag and drop")
                //           ],
                //         ),
                //         const Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text("SVG, PNG, JPG or GIF (max. 800x400px)")
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                if (widget.experimentImagesMap['Question${widget.index}'] ==
                    null)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color.fromARGB(139, 249, 250, 251),
                      border: Border.all(
                        color: const Color.fromARGB(
                            107, 158, 158, 158), // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  _pickImageFromGallery(widget.index);
                                },
                                icon: const Icon(
                                    Icons.drive_folder_upload_rounded),
                                color: const Color.fromARGB(249, 60, 55, 55),
                                focusColor:
                                    const Color.fromARGB(204, 223, 112, 104),
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Click to upload ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7F56D9),
                              ),
                            ),
                            Text("or drag and drop")
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SVG, PNG, JPG or GIF (max. 800x400px)")
                          ],
                        )
                      ],
                    ),
                  )
                else
                  Stack(children: [
                    Image.file(
                      widget.experimentImagesMap['Question${widget.index}']!,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 30,
                          onPressed: () {
                            handleDeleteImage(widget.index);
                          },
                          icon: const Icon(Icons.cancel),
                          color: const Color.fromARGB(212, 255, 72, 0),
                          focusColor: const Color.fromARGB(204, 223, 112, 104),
                        ),
                      ),
                    ),
                  ]),

                if (dropdownValue != 'Open Ended')
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dropdownValue == 'True False'
                                  ? 2
                                  : dropdownValue == 'Multiple Choice'
                                      ? 4
                                      : 0,
                              itemBuilder: (context, index) => RadioTextField(
                                radioIndex: index + 1,
                                // selectedCorrectAnswer: widget.selectedAnswer,
                                width: constraints.maxWidth,
                                qIndex: widget.index,
                                createQuestionjson: widget.createQuestionJson,
                                handleSelectedOption:
                                    widget.handleSelectedOption,
                                selectedAnswersMap: widget.selectedAnswersMap,
                                trueOrFalse: dropdownValue == 'True False'
                                    ? true
                                    : false,
                                validator: (val) {
                                  if (!val!.isValidOption) {
                                    return 'Option is required';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  if (dropdownValue == 'True False') return;
                                  debugPrint('At line 339 multiquestion_dart');
                                  setState(
                                    () {
                                      options.length == 4
                                          ? null
                                          : options.add(val!);
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                Visibility(
                  visible: dropdownValue == 'Open Ended' ? false : true,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("(Select an option as correct answer)"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: (widget.templateLength - 1) == widget.index
                      ? true
                      : false,
                  child: SizedBox(
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
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (widget.selectedAnswersMap[
                                          "Question${widget.index}"] ==
                                      null &&
                                  dropdownValue != 'Open Ended') {
                                showDialog(
                                    context: context,
                                    builder: (context) => const UniversalToast(
                                          state: 'error',
                                          errorTitle:
                                              'Please select a correct answer',
                                          errMessage:
                                              'Your question can not be created',
                                        ));
                                return;
                              }

                              debugPrint('Index is: ${widget.index}');
                              if (dropdownValue == 'Open Ended' &&
                                  widget.experimentImagesMap[
                                          'Question${widget.index}'] ==
                                      null) {
                                showDialog(
                                    context: context,
                                    builder: (context) => const UniversalToast(
                                          state: 'error',
                                          errorTitle: 'Please select an image',
                                          errMessage:
                                              'Your question can not be created',
                                        ));
                                return;
                              }

                              widget.handleCreateQuestion(
                                  ApiResCreateQuestion(
                                      question_title: title,
                                      type: dropdownValue,
                                      image: widget.experimentImagesMap[
                                                  'Question${widget.index}'] ==
                                              null
                                          ? File('')
                                          : widget.experimentImagesMap[
                                              'Question${widget.index}']!,
                                      option: dropdownValue == 'True False'
                                          ? ['true', 'false']
                                          : options,
                                      correct_option:
                                          dropdownValue == 'Open Ended'
                                              ? 'N/A'
                                              : widget.selectedAnswersMap[
                                                  "Question${widget.index}"],
                                      points: points,
                                      test_id: 1),
                                  widget.index);

                              /// create a new question form

                              widget.handleAddQuestion();
                              debugPrint('Print after handleAddQuestion');

                              // _formKey.currentState!.reset();
                            }
                          },
                          child: const Text(
                            "+ Add question",
                            style: TextStyle(
                                color: Color(0xFF7F56D9),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: non_constant_identifier_names
import 'dart:io';

class Question {
  final String title;
  final List<String> options;
  final String correctAnswer;
  final String type;

  Question({
    required this.title,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });
}

class Answer {
  final String questionTitle;
  final int? selectedOption;
  final String? openEndedAnswer;
  final String isCorrect;
  final List<String> options;
  final String? type;

  Answer({
    required this.questionTitle,
    this.selectedOption,
    this.openEndedAnswer,
    required this.isCorrect,
    required this.options,
    required this.type,
  });
}

class CreateQuestion {
  final String qIndex;
  final int? correctAnswer;

  CreateQuestion({
    required this.qIndex,
    this.correctAnswer,
  });
}

class ApiResCreateQuestion {
  String question_title;
  String points;
  File image;
  List<String> option;
  String type;
  Object correct_option;
  int test_id;

  ApiResCreateQuestion(
      {required this.question_title,
      required this.points,
      required this.image,
      required this.option,
      required this.type,
      required this.correct_option,
      required this.test_id});

  Map<String, dynamic> toJson() {
    return {
      'question_title': question_title,
      'points': points,
      'image': image.path, // Assuming you want to store the file path
      'option': option,
      'type': type,
      'correct_option': correct_option,
      'test_id': test_id,
    };
  }

  @override
  String toString() {
    return 'ApiResCreateQuestion(question_title: $question_title, points: $points, option: $option, image:$image, type: $type, correct_answer: $correct_option)';
  }
}

class TitleAndDescription {
  String title;
  String description;
  TitleAndDescription({required this.title, required this.description});
}

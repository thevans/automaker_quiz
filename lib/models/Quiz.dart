import 'package:automaker_quiz/models/Question.dart';

class Quiz {
  final List<Question> questions;

  Quiz({this.questions});

  factory Quiz.fromJson(List<dynamic> json) {
    List<Question> qs = new List<Question>();

    for (dynamic question in json) {
      qs.add(Question.fromJson(question));
    }

    return Quiz(
      questions: json != null ? qs : null,
    );
  }

  List<dynamic> toJson() {
    List<dynamic> data = new List<String>();
    if (this.questions != null) {
      data = this.questions;
    }
    return data;
  }
}
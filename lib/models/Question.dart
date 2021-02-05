import 'package:automaker_quiz/models/Answer.dart';

class Question {
    List<Answer> answers;
    int id;
    String title;

    Question({this.answers, this.id, this.title});

    factory Question.fromJson(Map<String, dynamic> json) {
        return Question(
            answers: json['answers'] != null ? (json['answers'] as List).map((i) => Answer.fromJson(i)).toList() : null, 
            id: json['id'], 
            title: json['title'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['title'] = this.title;
        if (this.answers != null) {
            data['answers'] = this.answers.map((v) => v.toJson()).toList();
        }
        return data;
    }
}
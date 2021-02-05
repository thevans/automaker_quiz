import 'dart:math';

import 'package:automaker_quiz/models/Answer.dart';
import 'package:automaker_quiz/models/Question.dart';
import 'package:automaker_quiz/models/Quiz.dart';
import 'package:automaker_quiz/networking/Response.dart';

class QuizController {
  List<Question> _questionBank;
  int questionIndex = 0;
  int hitNumber = 0;

  int get questionsNumber => _questionBank?.length ?? 0;
  Question get question => _questionBank[questionIndex];

  QuizController(Response<Quiz> data)
  {
    hitNumber = 0;
    _questionBank = data.data.questions;
  }

  void nextQuestion(int index) {
    questionIndex = index;
  }

  String getQuestion(int index) {
    return _questionBank[index].title;
  }

  List<Answer> getAnswers(int index) {
    return _questionBank[index].answers;
  }

  bool correctAnswer(Answer answer) {
    var correct = _questionBank[questionIndex].answers == answer;
    hitNumber = hitNumber + (correct ? 1 : 0);
    return correct;
  }
}

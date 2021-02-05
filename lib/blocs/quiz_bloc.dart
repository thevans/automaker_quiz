import 'dart:async';

import 'package:automaker_quiz/models/Quiz.dart';
import 'package:automaker_quiz/networking/Response.dart';
import 'package:automaker_quiz/repository/quiz_repository.dart';

class QuizBloc {
  QuizRepository _quizRepository;
  StreamController _questionListController;

  StreamSink<Response<Quiz>> get questionListSink =>
      _questionListController.sink;

  Stream<Response<Quiz>> get quizListStream =>
      _questionListController.stream;

  QuizBloc() {
    _questionListController = StreamController<Response<Quiz>>();
    _quizRepository = QuizRepository();
    fetchQuiz();
  }

  fetchQuiz() async {
    questionListSink.add(Response.loading('Getting questions...'));
    try {
      Quiz quiz = await _quizRepository.fetchQuizData();
      questionListSink.add(Response.completed(quiz));
    } catch (e) {
      questionListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _questionListController?.close();
  }
}

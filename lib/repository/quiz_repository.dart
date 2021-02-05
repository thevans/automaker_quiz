import 'dart:async';

import 'package:automaker_quiz/models/Quiz.dart';
import 'package:automaker_quiz/networking/ApiProvider.dart';

class QuizRepository {
  ApiProvider _provider = ApiProvider();

  Future<Quiz> fetchQuizData() async {
    final response = await _provider.get("questions");
    return Quiz.fromJson(response);
  }
}

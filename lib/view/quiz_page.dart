import 'package:auto_size_text/auto_size_text.dart';
import 'package:automaker_quiz/blocs/quiz_bloc.dart';
import 'package:automaker_quiz/models/Answer.dart';
import 'package:automaker_quiz/models/Quiz.dart';
import 'package:automaker_quiz/networking/Response.dart';
import 'package:flutter/material.dart';
import 'package:automaker_quiz/components/centered_circular_progress.dart';
import 'package:automaker_quiz/components/centered_message.dart';
import 'package:automaker_quiz/components/finish_dialog.dart';
import 'package:automaker_quiz/controllers/quiz_controller.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizController _controller;
  int score = 0;
  List<Answer> _scoreKeeper = [];
  bool _loading = true;
  int index = 0;

  QuizBloc _bloc;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _bloc = QuizBloc();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.grey.shade900,
        title: Text('Quiz das Montadoras'),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: StreamBuilder<Response<Quiz>>(
          stream: _bloc.quizListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return  CenteredCircularProgress();

            WidgetsBinding.instance.addPostFrameCallback((_){
              setState(() {
                _controller = QuizController(snapshot.data);
              });
            });

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildQuiz(snapshot.data),
            );
          }
        ),
      ),
    );
  }

  _buildQuiz(Response<Quiz> data) {
    if (_loading) return CenteredCircularProgress();
    if (_controller == null) return CenteredCircularProgress();

    if (_controller.questionsNumber == 0)
      return CenteredMessage(
        'Nenhuma pergunta disponível',
        icon: Icons.warning,
      );

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildComponents(_controller.getAnswers(index))
    );
  }

  _buildQuestion(String question) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            "Qual o país de origem da: \n$question?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _buildComponents(List<Answer> answers){
    var answerButtons = new List<Widget>();

    answerButtons.add(_buildQuestion(_controller.getQuestion(index)));

    for (Answer answer in _controller.getAnswers(index)) {
      answerButtons.add(_buildAnswerButton(answer));
    }

    return answerButtons.toList();
  }

  _buildAnswerButton(Answer answer) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.blue,
            child: Center(
              child: AutoSizeText(
                answer.title,
                maxLines: 2,
                minFontSize: 10.0,
                maxFontSize: 32.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _scoreKeeper.add(answer);
              print(answer.toJson());

              _controller.questionIndex = _controller.questionIndex++;

              if (_scoreKeeper.length < _controller.questionsNumber) {
                index++;
                _controller.nextQuestion(index);

                setState(() { });
              } else {
                for (var scoreKeeper in _scoreKeeper) {
                  if (scoreKeeper.correct)
                    score++;
                }

                FinishDialog.show(
                    context,
                    score: score,
                    questionNumber: _controller.questionsNumber
                );
              }
            });
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'quiz_page_state.dart';

class QuizPage extends StatelessWidget {
  final int numOfQuestions;
  final int categoryId;
  final String categoryName;
  final String difficultyId;

  QuizPage(
      {@required this.numOfQuestions,
      @required this.categoryId,
      @required this.categoryName,
      @required this.difficultyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Quiz Page'),
      ),
      body: QuizPageState(
        stateNumOfQuestions: numOfQuestions,
        stateCategoryId: categoryId,
        stateCategoryValue: categoryName,
        stateDifficultyId: difficultyId,
      ),
    );
  }
}

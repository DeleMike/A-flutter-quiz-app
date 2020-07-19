import 'package:flutter/material.dart';
import 'package:quiz_app/result.dart';
import 'quiz_page.dart';
import 'login_page.dart';
import 'welcome_page.dart';
import 'select_question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  static final String welcomePage = '/welcomePage';
  static final String selectQuestion = '/selectQuestion';
  static final String quizPage = '/quizPage';
  static final String resultPage = '/resultPage';

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => LoginPage(),
         welcomePage : (context) => WelcomePage(''),
         selectQuestion : (context) => SelectQuestion(),
         quizPage : (context) => QuizPage(numOfQuestions: 0, categoryId: 0, categoryName: '', difficultyId: ''),
         resultPage: (context) => ResultPage(courseTaken: '', courseScore: '', theScore: 0, totalQuestion: 0),
      },
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}



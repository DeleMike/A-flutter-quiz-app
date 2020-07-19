import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiver/async.dart';
import 'package:html/parser.dart';
import 'package:quiz_app/result.dart';

class QuizPageState extends StatefulWidget {
  final int stateNumOfQuestions;
  final int stateCategoryId;
  final String stateCategoryValue;
  final String stateDifficultyId;

  QuizPageState(
      {@required this.stateNumOfQuestions,
      @required this.stateCategoryId,
      @required this.stateCategoryValue,
      @required this.stateDifficultyId});

  @override
  _QuizPageStateWidget createState() => _QuizPageStateWidget(
      widgetNumOfQuestions: stateNumOfQuestions,
      widgetCategoryId: stateCategoryId,
      widgetCategoryValue: stateCategoryValue,
      widgetDifficultyId: stateDifficultyId);
}

enum OptionValue { True, False }

class _QuizPageStateWidget extends State<QuizPageState> {
  final String url = 'www.opentdb.com';
  int widgetNumOfQuestions;
  int widgetCategoryId;
  String widgetCategoryValue;
  String widgetDifficultyId;

  OptionValue _optionValue = OptionValue.True;
  List questions;
  List questionsOnly;
  List correctAnswers;
  int questionIndex = 0;
  int questionScore = 0;
  int currentTimer = 0;
  String _questionHeader;
  String _correctAnswer;
  int _totalQuestion;
  int durationTime = 0;
  bool answered = false;
  String _buttonText = "GO";
  CountdownTimer _countdownTimer;
  Map<String, String> queryParameters;
  int successVal = 0;
  var _sub;

  _QuizPageStateWidget(
      {@required this.widgetNumOfQuestions,
      @required this.widgetCategoryId,
      @required this.widgetCategoryValue,
      @required this.widgetDifficultyId});

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Error in setState'), duration: Duration(seconds: 2)));
    }
  }

  @override
  void initState() {
    super.initState();

    print('\nOn Start ==> widgetCategoryId = $widgetCategoryId' +
        '\nwidgetCategoryValue = $widgetCategoryValue' +
        '\ndifficultyId = $widgetDifficultyId' +
        '\nNumOfQuestion = $widgetNumOfQuestions');
    queryParameters = {
      'amount': widgetNumOfQuestions.toString(),
      'category': widgetCategoryId.toString(),
      'difficulty': widgetDifficultyId,
      'type': 'boolean',
    };

    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var uri = Uri.https(url, '/api.php', queryParameters);
    String returnVal = '';
    var response = await http.get(
        //encode the url
        uri,
        //only accept Json response
        headers: {'Accept': 'application/json'});

    //print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      questions = convertDataToJson['results'];
      int length = questions.length;
      print('List for questions json data is: $length');
      if (length == 0) {
        getDefaultQuestion();
        successVal = 0;
        returnVal = 'failed';
      } else {
        questionsOnly = new List(questions.length);
        correctAnswers = new List(questions.length);
        //var idVal = questions[0]['question'];
        // print('The questions are = $idVal');
        for (int i = 0; i < questions.length; i++) {
          questionsOnly[i] = parseHtmlString(questions[i]['question']);
          correctAnswers[i] = questions[i]['correct_answer'];
        }
        print('\nQuestions = $questionsOnly');
        print('\nCorrectAnswers = $correctAnswers');

        loadQuestions(questionsOnly, correctAnswers);
        successVal = 1;
        returnVal = 'success';
      }
      //var length = questions.length;
      print('\nThese are the questions = $questions');
      print('\nsuccess list size is $length');
    });

    print('From getJson() successVal is now = $successVal');
    return returnVal;
  }

  String parseHtmlString(String value) {
    var document = parse(value);
    String parsedStr = parse(document.body.text).documentElement.text;
    return parsedStr;
  }

  getDefaultQuestion() async {
    showDialog<void>(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Message'),
            content: const Text('The question you selected does not exist.' +
                '\nDon\'t worry we have selected some nice ones for you!'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Okay'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });

    widgetCategoryId = 0;

    loadQuestionsAgain(
        widgetCategoryId, widgetDifficultyId, widgetNumOfQuestions);
    print('From getDefaultQuestions() successVal is now = $successVal');
  }

  loadQuestionsAgain(int widgetCategoryId, String widgetDifficultyId,
      int widgetNumOfQuestions) async {
    queryParameters = {
      'amount': widgetNumOfQuestions.toString(),
      'category': widgetCategoryId.toString(),
      'difficulty': widgetDifficultyId,
      'type': 'boolean',
    };

    print('From loadQuestionsAgain() successVal is now = $successVal');

    getJsonData();
  }

  loadQuestions(List questions, List answers) {
    _totalQuestion = questions.length;
    setState(() {
      _optionValue = null;
      if (questionIndex < _totalQuestion) {
        _questionHeader = questions[questionIndex];
        _correctAnswer = answers[questionIndex];
        questionIndex++;
        answered = false;

        if (questionIndex == _totalQuestion) {
          _buttonText = "FINISH";
        } else {
          _buttonText = "CONFIRM";
        }

        if (widgetDifficultyId == 'easy') {
          durationTime = 20;
          currentTimer = 20;
        } else if (widgetDifficultyId == 'medium') {
          durationTime = 30;
          currentTimer = 30;
        } else {
          durationTime = 40;
          currentTimer = 40;
        }

        startCountDown(durationTime);
      } else {
        finishQuiz();
      }
    });

    print('\nQuestion Index = $questionIndex');
    print('\nQuestion Total = $_totalQuestion');
  }

  void _buttonListener() {
    if (!answered) {
      if (_optionValue != null) {
        checkAnswer(_correctAnswer);
      } else {
        Scaffold.of(this.context).showSnackBar(SnackBar(
          content: Text('No \'CONFIRMED\' option selected!'),
          duration: Duration(seconds: 1),
        ));
      }
    } else {
      loadQuestions(questionsOnly, correctAnswers);
    }
  }

  void startCountDown(int duration) {
    _countdownTimer =
        CountdownTimer(Duration(seconds: duration), Duration(seconds: 1));

    _sub = _countdownTimer.listen(null);
    _sub.onData((timing) {
      setState(() {
        currentTimer = durationTime - timing.elapsed.inSeconds;
        if (currentTimer == 7) {
          Scaffold.of(this.context).showSnackBar(SnackBar(
            content: Text(
                'You have only 7 seconds left!\nHurry and click \'CONFIRM\' to record your answer'),
            duration: Duration(seconds: 4),
          ));
        } else if (currentTimer == 0) {
          Scaffold.of(this.context).showSnackBar(SnackBar(
            content: Text('No CONFIRMED option selected!'),
            duration: Duration(seconds: 1),
          ));
          checkAnswer(''); //passing '' because no option was selected
        }
      });
    });

    _sub.onDone(() {
      print('Timer canceled');
      _sub.cancel();
    });
  }

  void checkAnswer(String markedAnswer) {
    String selectedAnswer, correctAnswer = '';
    setState(() {
      showAnotherQuestion();
      answered = true;
      _countdownTimer.cancel();

      selectedAnswer = _optionValue.toString();
      print('\nFrom checkAnswer, Selected Answer is = $selectedAnswer');

      if (selectedAnswer == null) {
        selectedAnswer = '';
      } else if (markedAnswer == 'False') {
        correctAnswer = 'OptionValue.False';
      } else if (markedAnswer == 'True') {
        correctAnswer = 'OptionValue.True';
      }

      if (selectedAnswer == correctAnswer) {
        questionScore++;
        Scaffold.of(this.context).showSnackBar(SnackBar(
          content: Text('Correct!'),
          duration: Duration(seconds: 1),
        ));
      } else {
        Scaffold.of(this.context).showSnackBar(SnackBar(
          content: Text('Incorrect!'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  //Pass the value score value and the course taken
  void finishQuiz() {
    print('\nScore = $questionScore');
    print('\nTotal Question = $_totalQuestion');
    String score = '$questionScore/$_totalQuestion';
    Route route = MaterialPageRoute(
        builder: (context) => ResultPage(
              courseTaken: widgetCategoryValue,
              courseScore: score,
              theScore: questionScore,
              totalQuestion: _totalQuestion,
            ));
    Navigator.pushReplacement(context, route);
  }

  void showAnotherQuestion() {
    setState(() {
      if (questionIndex < _totalQuestion) {
        _buttonText = 'NEXT';
      } else {
        _buttonText = 'FINISH';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (successVal == 1) {
      return ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Text(
                  'Score: $questionScore',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(8.0),
                  alignment: FractionalOffset.topRight,
                  child: Text(
                    'Time: $currentTimer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Question: $questionIndex/$_totalQuestion',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              '$_questionHeader',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                RadioListTile(
                  title: const Text(
                    'True',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  value: OptionValue.True,
                  groupValue: _optionValue,
                  activeColor: Colors.green,
                  onChanged: (OptionValue val) {
                    setState(() => _optionValue = val);
                    print('\nClicked button = $_optionValue');
                  },
                ),
                RadioListTile(
                  title: const Text(
                    'False',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  value: OptionValue.False,
                  groupValue: _optionValue,
                  activeColor: Colors.green,
                  onChanged: (OptionValue val) {
                    setState(() => _optionValue = val);
                    // var value = val.toString();
                    // bool ans = value == ('OptionValue.False');
                    print('\nClicked button = $_optionValue');
                    // print('Are they the same = $ans');
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.0),
            alignment: FractionalOffset.bottomRight,
            child: MaterialButton(
              height: 50.0,
              minWidth: 150.0,
              color: Colors.lightGreen,
              splashColor: Colors.green,
              textColor: Colors.white,
              child: Text('$_buttonText'),
              onPressed: _buttonListener,
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      _countdownTimer.cancel();
      _sub.cancel();
    });
  }
}

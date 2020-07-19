import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';

class ResultPage extends StatelessWidget {
  final String courseTaken;
  final String courseScore;
  final int theScore;
  final int totalQuestion;
  final String poorResultImage = 'assets/images/green_frowny.png';
  final String goodResultImage = 'assets/images/result_page_pic.png';

  ResultPage(
      {@required this.courseTaken,
      @required this.courseScore,
      @required this.theScore,
      @required this.totalQuestion});

  @override
  Widget build(BuildContext context) {
    String chosenImage = '';
    String message = '';
    if (theScore == 0) {
      chosenImage = poorResultImage;
      message = 'Oh you can try again!';
    } else if (theScore == totalQuestion) {
      chosenImage = goodResultImage;
      message = 'Wow! You got all the questions!';
    } else {
      chosenImage = goodResultImage;
      message = 'Nice one, you did well!';
    }
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Results'),
      ),
      body: Card(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                '$chosenImage',
                alignment: Alignment.center,
                height: 150,
                width: 150,
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('$message', textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Course Taken : $courseTaken',
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Score : $courseScore', textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      splashColor: Colors.green,
                      textColor: Colors.lightGreen,
                      child: Text('Finish'),
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Message'),
                                content: const Text(
                                    'Are you sure you want to exit the app?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: const Text('Yes'),
                                    onPressed: () => exit(0),
                                  ),
                                  FlatButton(
                                    child: const Text('No'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            });
                      }),
                  MaterialButton(
                      elevation: 4.0,
                      height: 50.0,
                      minWidth: 150.0,
                      color: Colors.lightGreen,
                      splashColor: Colors.green,
                      textColor: Colors.white,
                      child: Text('Take again'),
                      onPressed: () {
                        Navigator.pushNamed(context, MyApp.selectQuestion);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

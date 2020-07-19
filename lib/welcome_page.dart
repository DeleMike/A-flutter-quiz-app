import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/main.dart';

class WelcomePage extends StatelessWidget {
  final String name;

  WelcomePage(this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hi $name, ' +
                    _timeOfDay() +
                    ' ready for the challenge?\nOr do you think you are worthy enough to answer us? ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.insert_emoticon,
                  color: Colors.black,
                  size: 200.0,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(16.0),
                    padding: EdgeInsets.all(16.0),
                    child: MaterialButton(
                      height: 50.0,
                      minWidth: 150.0,
                      color: Colors.lightGreen,
                      splashColor: Colors.green,
                      textColor: Colors.white,
                      child: Text('GO'),
                      onPressed: () {
                        Navigator.pushNamed(context, MyApp.selectQuestion);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeOfDay() {
    String timeOfDay = '';
    DateTime now = DateTime.now();
    var hour;
    hour = int.parse(DateFormat('kk').format(now));
    //int hourInt = int.parse(hour);
    if (hour < 12) {
      timeOfDay = 'Good Morning!';
    } else if (hour >= 12 && hour < 16) {
      timeOfDay = 'Good Afternoon!';
    } else if (hour >= 16 && hour < 21) {
      timeOfDay = 'Good Evening!';
    } else {
      timeOfDay = 'Night is here!';
    }

    return timeOfDay;
  }
}

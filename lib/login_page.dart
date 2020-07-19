import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  static final userName = 'UserName';
  static final loggedIn = 'loggedIn';
  bool newUser;
  SharedPreferences sharedPref;
  final loginController = TextEditingController();
  int successVal = 0;

  Future _checkIfLoggedIn() async {
    sharedPref = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPref.getBool(loggedIn);
    if (isLoggedIn) {
      getNamePref();
      Route route = MaterialPageRoute(builder: (context) => WelcomePage(sharedPref.getString(userName)));
      Navigator.pushReplacement(context, route);
      successVal = 1;
    }
  }

  Future _saveName(String name) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(userName, name);
    sharedPref.setBool(loggedIn, true);
  }

  Future getNamePref() async {
    sharedPref = await SharedPreferences.getInstance();
    String name = sharedPref.getString(userName);
    bool isLoggedIn = sharedPref.getBool(loggedIn);

    print('Name = $name, login_status = $isLoggedIn');
  }


  @override
  void initState() {
    super.initState();
     _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    if(successVal == 1){
      return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: loginController,
                inputFormatters: [LengthLimitingTextInputFormatter(8)],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(3.0),
                    ),
                  ),
                  icon: Icon(Icons.person_add),
                  labelText: 'Enter your quiz name',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                height: 50.0,
                minWidth: 150.0,
                color: Colors.lightGreen,
                splashColor: Colors.green,
                textColor: Colors.white,
                child: Text('Submit'),
                onPressed: () {
                  _saveName(loginController.text);
                  getNamePref();
                  Route route =
                      MaterialPageRoute(builder: (context) => WelcomePage(loginController.text));
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ],
        ),
      ),
    );
    }else{

      return Scaffold(
        body: Center(
       child: Stack(
          alignment: FractionalOffset.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
      );
    }
    
  }

  @override
  void dispose() {
    //clean up the controller when the widget is disposed.
    loginController.dispose();
    super.dispose();
  }
}

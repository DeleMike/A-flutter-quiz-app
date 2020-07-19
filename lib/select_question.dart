import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Category.dart';
import 'difficulty.dart';
import 'quiz_page.dart';
import 'dart:io';

class SelectQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Question Type')),
      body: SelectQuestionForm(),
    );
  }
}

class SelectQuestionForm extends StatefulWidget {
  @override
  _SelectQuestionFormWidget createState() => _SelectQuestionFormWidget();
}

class _SelectQuestionFormWidget extends State<SelectQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  List<Difficulty> _difficulties = Difficulty.getDifficulties();
  List<DropdownMenuItem<Difficulty>> _dropDownMenuItems;
  Difficulty _selectedDifficulty;

  List<Category> _categories = Category.getCategories();
  List<DropdownMenuItem<Category>> _dropDownCategoryMenuItems;
  Category _selectedCategory;
  bool connectionStatus = false;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildDropDownMenuItems(_difficulties);
    _selectedDifficulty = _dropDownMenuItems[0].value;
    _dropDownCategoryMenuItems = buildDropDownCategoryItems(_categories);
    _selectedCategory = _dropDownCategoryMenuItems[0].value;
  }

  List<DropdownMenuItem<Difficulty>> buildDropDownMenuItems(List difficulties) {
    List<DropdownMenuItem<Difficulty>> items = List();
    for (Difficulty difficulty in difficulties) {
      items.add(
        DropdownMenuItem(
          value: difficulty,
          child: Text(difficulty.value),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Category>> buildDropDownCategoryItems(List categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.value),
        ),
      );
    }
    return items;
  }

  Future<bool> checkForInternetConnection() async {
    connectionStatus = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
        print(
            '\nInternet status: connected || connection status = $connectionStatus');
      }
    } on SocketException {
      connectionStatus = false;
      print(
          '\nInternet status: not connected || connection status = $connectionStatus');
    }
    return connectionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('[0-9]'))
                    ],
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      icon: Icon(Icons.mode_edit),
                      labelText: 'Enter number of questions',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a value';
                      } else if (int.parse(value) < 1 ||
                          int.parse(value) > 50) {
                        return 'Please enter a value between 1 and 50';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Select question category',
                        style: TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: _selectedCategory,
                        items: _dropDownCategoryMenuItems,
                        onChanged: (Category selectedCategory) {
                          setState(() {
                            _selectedCategory = selectedCategory;
                          });
                        },
                        elevation: 4,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Select a Difficulty',
                        style: TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: _selectedDifficulty,
                        items: _dropDownMenuItems,
                        onChanged: (Difficulty selectedDifficulty) {
                          setState(() {
                            _selectedDifficulty = selectedDifficulty;
                          });
                        },
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                ),
                Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      height: 50.0,
                      minWidth: 150.0,
                      color: Colors.lightGreen,
                      splashColor: Colors.green,
                      textColor: Colors.white,
                      child: Text('GO'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          bool connectState =
                              await checkForInternetConnection();
                          if (connectState) {
                            Route route = MaterialPageRoute(
                                builder: (context) => QuizPage(
                                    numOfQuestions: int.parse(_controller.text),
                                    categoryId: _selectedCategory.id,
                                    categoryName: _selectedCategory.value,
                                    difficultyId: _selectedDifficulty.id));
                            Navigator.pushReplacement(context, route);
                          } else {
                            //    Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text(
                            //       'Please make sure you are connected to the internet.'),
                            //   duration: Duration(seconds: 4),
                            // ));

                            showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Message'),
                                    content: const Text(
                                        'Please make sure you are connected to the internet.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

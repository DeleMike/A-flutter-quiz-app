import 'package:flutter/material.dart';

class Difficulty {
  String id, value;
  Difficulty({@required this.id, @required this.value});

  static List<Difficulty> getDifficulties() {
    return <Difficulty>[
      Difficulty(id: 'easy', value: 'Easy'),
      Difficulty(id: 'medium', value: 'Medium'),
      Difficulty(id: 'hard', value: 'Hard'),
    ];
  }
}

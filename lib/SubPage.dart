import 'package:flutter/material.dart';
import 'package:pomodoro_ios_app/Header.dart';

import 'Header.dart';

class SubPage extends StatelessWidget {
  const SubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Header('pop'),
        ],
      ),
      backgroundColor: Colors.grey[800],
    );
  }
}

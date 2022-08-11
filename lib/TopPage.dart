import 'package:flutter/material.dart';
import 'package:pomodoro_ios_app/Header.dart';

import 'Header.dart';
import 'TaskInfo.dart';
import 'TaskButton.dart';

class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 現在の日時表示
          const Header('push'),
          // タスク表示
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Center(
                child: TaskInfo(),
              ),
              // タスクボタン
              TaskButton(),
            ],
          )
        ],
      ),
      backgroundColor: Colors.grey[800],
    );
  }
}

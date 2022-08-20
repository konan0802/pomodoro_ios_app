import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'TogglTask.dart';
import 'TaskTime.dart';
import 'config.dart';

class TaskInfo extends StatefulWidget {
  const TaskInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaskInfoState();
  }
}

class _TaskInfoState extends State<TaskInfo> {
  /// タイマー文字列用
  String _taskName = '';
  int _pjtId = 0;
  int _taskTime = 0;
  String _taskTimeMinutes = '';
  String _taskTimeSeconds = '';

  int _taskInfoCllorR = 66;
  int _taskInfoCllorG = 66;
  int _taskInfoCllorB = 66;

  @override
  void initState() {
    super.initState();

    // 現在タスクの管理
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      fetchTogglTask();
    });

    // アラート管理
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      manageTaskInfoColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 530.h,
        padding: EdgeInsets.only(top: 50.h, left: 15.w, right: 20.w),
        margin: EdgeInsets.only(top: 130.h, left: 25.w),
        decoration: BoxDecoration(
          color: Color.fromARGB(
            255,
            _taskInfoCllorR,
            _taskInfoCllorG,
            _taskInfoCllorB,
          ),
          border: Border.all(
            color: Colors.white,
            width: 3.0.w,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 74.sp,
              padding: EdgeInsets.only(top: 6.h, left: 10.w),
              child: Text(
                _taskName,
                style: TextStyle(
                  fontSize: 70.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            Container(
              width: 355.w,
              margin: EdgeInsets.only(left: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TaskTime(_taskTimeMinutes, _taskTimeSeconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchTogglTask() async {
    String url = 'https://api.track.toggl.com/api/v8/time_entries/current';
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Basic ' +
          base64Encode(utf8.encode(dotenv.env['TOGGL_API_KEY']! + ':api_token'))
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    // 一時的な[Too Many Requests]のレスポンスは握り潰す
    if (response.statusCode == 429) {
      return;
    }
    try {
      TogglTask togglTask =
          TogglTask.fromJson(jsonDecode(response.body)["data"]);

      // タスク経過時間 = 現在の時刻 - タスクの開始時刻
      var now = DateTime.now();
      var start = DateTime.parse(togglTask.start);
      _taskTime = now.difference(start).inSeconds;
      var durationM = _taskTime ~/ 60;
      var durationS = _taskTime % 60;
      if (mounted) {
        setState(() {
          _taskTimeMinutes = durationM == null ? "?" : durationM.toString();
          _taskTimeSeconds = durationS == null ? "?" : durationS.toString();
          _taskName = togglTask.description;
          _pjtId = togglTask.pid;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _taskTimeMinutes = "?";
          _taskTimeSeconds = "??";
          _taskName = NT;
        });
      }
    }
  }

  /*
    アラート条件
    ・NT         : アラート
    ・WORK       : 25分以上でアラート
    ・MTG        : 30分以上でアラート
    ・FIVE_BRK   : 5分以上でアラート
    ・TEN_BRK    : 10分以上でアラート
    ・THIRTY_BRK : 30分以上でアラート
    ・上記以外 : デフォルト
  */
  void manageTaskInfoColor() {
    if (_taskName == NT) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else if (_pjtId == STATE_PJT['WORK'] &&
        _taskTime >= STATE_TIME['WORK']!.toInt()) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else if (_taskName == STATE_TASK['MTG'] &&
        _pjtId == STATE_PJT['MTG'] &&
        _taskTime >= STATE_TIME['MTG']!.toInt()) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else if (_taskName == STATE_TASK['SBRK'] &&
        _pjtId == STATE_PJT['BRK'] &&
        _taskTime >= STATE_TIME['SBRK']!.toInt()) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else if (_taskName == STATE_TASK['LBRK'] &&
        _pjtId == STATE_PJT['BRK'] &&
        _taskTime >= STATE_TIME['LBRK']!.toInt()) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else if (_taskName == STATE_TASK['30BRK'] &&
        _pjtId == STATE_PJT['BRK'] &&
        _taskTime >= STATE_TIME['30BRK']!.toInt()) {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 191;
          _taskInfoCllorG = 67;
          _taskInfoCllorB = 67;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _taskInfoCllorR = 66;
          _taskInfoCllorG = 66;
          _taskInfoCllorB = 66;
        });
      }
    }
  }
}

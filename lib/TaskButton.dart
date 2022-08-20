import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config.dart';

class TaskButton extends StatefulWidget {
  const TaskButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaskButtonState();
  }
}

class _TaskButtonState extends State<TaskButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 150.h, left: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('images/work.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(STATE_TASK['WORK'].toString(),
                      STATE_PJT['WORK']!.toInt());
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/sbrk.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(STATE_TASK['SBRK'].toString(),
                      STATE_PJT['SBRK']!.toInt());
                },
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('images/mtg.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(
                      STATE_TASK['MTG'].toString(), STATE_PJT['MTG']!.toInt());
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/lbrk.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(STATE_TASK['LBRK'].toString(),
                      STATE_PJT['LBRK']!.toInt());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> setTogglTask(String taskName, int pid) async {
    String url = 'https://api.track.toggl.com/api/v8/time_entries/start';
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Basic ' +
          base64Encode(utf8.encode(dotenv.env['TOGGL_API_KEY']! + ':api_token'))
    };
    String body = json.encode({
      'time_entry': {
        'description': taskName,
        'created_with': 'time_tracker',
        "pid": pid
      }
    });
    http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (resp.statusCode != 200) {
      print(resp.body);
    }
  }

  Future<void> stopTogglTask(String taskName, int pid) async {
    String url = 'https://api.track.toggl.com/api/v8/time_entries/start';
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Basic ' +
          base64Encode(utf8.encode(dotenv.env['TOGGL_API_KEY']! + ':api_token'))
    };
    String body = json.encode({
      'time_entry': {
        'description': taskName,
        'created_with': 'time_tracker',
        "pid": pid
      }
    });
    http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (resp.statusCode != 200) {
      print(resp.body);
    }
  }
}

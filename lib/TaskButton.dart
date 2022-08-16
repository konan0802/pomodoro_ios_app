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
      margin: EdgeInsets.only(top: 0.h, left: 4.w),
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
                  setTogglTask(WORK);
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/etc.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(ETC);
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/mtg.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(MTG);
                },
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('images/sbrk.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(SBRK);
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/lbrk.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(LBRK);
                },
              ),
              SizedBox(
                width: 100.w,
              ),
              IconButton(
                icon: Image.asset('images/done.png'),
                iconSize: 270.h,
                onPressed: () {
                  setTogglTask(DONE);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> setTogglTask(String taskName) async {
    String url = 'https://api.track.toggl.com/api/v8/time_entries/start';
    Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Basic ' +
          base64Encode(utf8.encode(dotenv.env['TOGGL_API_KEY']! + ':api_token'))
    };
    String body = json.encode({
      'time_entry': {'description': taskName, 'created_with': 'time_tracker'}
    });
    http.Response resp =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (resp.statusCode != 200) {
      print(resp.body);
    }
  }
}

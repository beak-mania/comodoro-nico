import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int currentSeconds = 25 * 60;
  int totalSeconds = currentSeconds;
  bool isRunning = false;
  bool isStarted = false;
  int totalPomodoros = 0;
  late Timer timer;

  void set_currentSeconds(int value){
    setState(() {
      int seconds = value * 60;
      currentSeconds = seconds;
      totalSeconds = currentSeconds;
    });
  }

  void onTick(Timer timer){
    if(totalSeconds == 0){
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        isStarted = false;
        totalSeconds = currentSeconds;

      });
      timer.cancel();
    } else{
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
    
  }

  void onStartPressed(){
    timer = Timer.periodic(
      const Duration(seconds: 1), 
      onTick,
    );
    setState(() {
      isRunning = true;
      isStarted = true;
    });
  }

  void onPausePressed(){
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    setState(() {
        isRunning = false;
        isStarted = false;
        totalSeconds = currentSeconds;

      });
      timer.cancel();
  }

  void onSettingPressed() {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SettingDialog( Parent_set_currentSeconds : set_currentSeconds );
      }
    );
  }

  String format(int seconds){
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 50),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning? onPausePressed : onStartPressed,
                    icon: Icon(isRunning? Icons.pause_circle_outline : Icons.play_circle_outline)
                  ),
                  IconButton(
                    iconSize: 23,
                    color: Theme.of(context).cardColor,
                    onPressed: isStarted ? onResetPressed :onSettingPressed, 
                    icon: Icon(isStarted ? Icons.refresh : Icons.settings),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text('$totalPomodoros', 
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ],
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
}

class SettingDialog extends StatefulWidget {
  final Function(int) Parent_set_currentSeconds;
  const SettingDialog({
    Key? key,
    required this.Parent_set_currentSeconds,
  }) : super(key: key);

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {

  final _secondTextEditController = TextEditingController();

  @override
  void dispose() {
    print('dispose!');
    _secondTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 7),
      backgroundColor: Theme.of(context).cardColor,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _secondTextEditController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: Theme.of(context).textTheme.headline1!.color,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
            ),
          ),
          Text('min', 
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 40,
              color: Theme.of(context).textTheme.headline1!.color,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            int value = int.parse(_secondTextEditController.text);
            widget.Parent_set_currentSeconds(value);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('apply')
        )
      ],
    );
  }
}
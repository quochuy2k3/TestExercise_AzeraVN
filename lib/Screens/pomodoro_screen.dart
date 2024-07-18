import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/Model/mode.dart';
import 'package:pomodoro/Model/user.dart';
import 'package:pomodoro/Screens/login_screen.dart';
import 'package:pomodoro/Widget/ToDoList.dart';
import 'package:provider/provider.dart';

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  //To ez scaler and format OOP
  Mode _pomodoro = Mode(id: 1, name: "Pomodoro");
  Mode _shortBreak = Mode(id: 2, name: "Short break");
  Mode _longBreak = Mode(id: 3, name: "Long break");
  final _player = AudioPlayer();

  // Default to Pomodoro mode
  // To know what's mode of the timer now
  int _modeNow = 1;

  static const oneSecond = Duration(seconds: 1);
  static const int _cyclesUntilLongBreak = 4;

  int selectedOption = 1;
  bool _isWorking = false;
  int _remainingTime = 0;
  int _completedCycles = 0;

  Timer? _timer;

  //initialization for streamBuilder use when start to end
  late StreamController<int> _streamController;

  // late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

// call checkConfig 1st to setup timer
  @override
  void initState() {
    super.initState();
    // _initializeNotifications();
    _streamController = StreamController<int>.broadcast();
    checkConfig();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  // void _initializeNotifications() {
  //   // TODO: Initialize FlutterLocalNotificationsPlugin
  // }

  //Just call timer end -- with duration 1 Second
  //Must check timer's working or not then use the logic finish to do st
  //Turn on music and show dialog
  void _startTimer() {
    // TODO: Implement the logic to start the timer
    // Start the timer based on the selected mode (Pomodoro, Short Break, or Long Break).
    // Use a timer or a periodic function to update the remaining time and trigger
    // the appropriate actions when each interval is completed.
    if (_isWorking) {
      _timer = Timer.periodic(oneSecond, (timer) {
        setState(() {
          if (_remainingTime <= 0) {
            timer.cancel();
            _showNotification(_getModeById(_modeNow)!.name, "Time's up!");
            _playSound();
          } else {
            _streamController.add(--_remainingTime);
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    // TODO: Implement the logic to reset the timer
    // Reset the timer to its initial state, clearing any ongoing intervals and
    // resetting the completed cycles count.
  }

  //Look its so long but ... =)))) Repeat your self
  //This function is the void to show dialog then choose option
  //Processing when press
  void _configureDurations() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController pomodoroController =
            TextEditingController(text: _pomodoro.values.toString());
        TextEditingController shortBreakController =
            TextEditingController(text: _shortBreak.values.toString());
        TextEditingController longBreakController =
            TextEditingController(text: _longBreak.values.toString());

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Configure Durations'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Baby step',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('10 min  •  5 min  •  10 min'),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                            checkConfig();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Popular',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('20 min  •  5 min  •  15 min'),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                            checkConfig();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Medium',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('40 min  •  8 min  •  20 min'),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                            checkConfig();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Extended',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('60 min  •  10 min  •  25 min'),
                      leading: Radio<int>(
                        value: 4,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                            checkConfig();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Custom',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Custom your duration'),
                      leading: Radio<int>(
                        value: 5,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ),
                    if (selectedOption == 5) ...[
                      TextField(
                        controller: pomodoroController,
                        decoration: const InputDecoration(
                          labelText: 'Pomodoro duration (min)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9]\d*')),
                        ],
                        onChanged: (value) {
                          _pomodoro.values =
                              int.tryParse(value) ?? _pomodoro.values;
                        },
                      ),
                      TextField(
                        controller: shortBreakController,
                        decoration: const InputDecoration(
                          labelText: 'Short break duration (min)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9]\d*')),
                        ],
                        onChanged: (value) {
                          _shortBreak.values =
                              int.tryParse(value) ?? _shortBreak.values;
                        },
                      ),
                      TextField(
                        controller: longBreakController,
                        decoration: const InputDecoration(
                          labelText: 'Long break duration (min)',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9]\d*')),
                        ],
                        onChanged: (value) {
                          _longBreak.values =
                              int.tryParse(value) ?? _longBreak.values;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _updateRemainingTime();
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //It so dialog too
  //But in this function. i set logic to automatic jump to next mode
  //Because of when show created Notification timer is canceled so This func
  //must call startTime again
  void _showNotification(String title, String body) {
    // TODO: Implement the logic to show a local notification
    // Display a local notification when each interval is completed, informing
    // the user about the end of the Pomodoro, Short Break, or Long Break.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              _stopSound();
              Navigator.of(context).pop();
              setState(() {
                if (_modeNow == 1) _completedCycles++;
                _completedCycles == _cyclesUntilLongBreak
                    ? (_modeNow = 3, _completedCycles = 0)
                    : (_modeNow == 1 ? _modeNow = 2 : _modeNow = 1);
                _updateRemainingTime();
                _startTimer();
              });
            },
          ),
        ],
      ),
    );
  }

  //This function to setup follow my logic
  //Support configTime when change option
  void checkConfig() {
    switch (selectedOption) {
      case 1:
        setState(() {
          applyChangeTime(10, 5, 10);
          _updateRemainingTime();
        });
        break;
      case 2:
        setState(() {
          applyChangeTime(20, 5, 15);
          _updateRemainingTime();
        });
        break;
      case 3:
        setState(() {
          applyChangeTime(40, 8, 20);
          _updateRemainingTime();
        });
        break;
      case 4:
        setState(() {
          applyChangeTime(60, 10, 25);
          _updateRemainingTime();
        });
        break;
      case 5:
        setState(() {
          _updateRemainingTime();
        });
    }
  }

  //Use for clean code no repeat
  void applyChangeTime(
      int pomodoroTime, int shortBreakTime, int longBreakTime) {
    _pomodoro.values = pomodoroTime;
    _shortBreak.values = shortBreakTime;
    _longBreak.values = longBreakTime;
  }

  //Turn on sound online
  void _playSound() {
    String soundUrl =
        'https://assets.mixkit.co/active_storage/sfx/603/603-preview.mp3';

    _player.play(UrlSource(soundUrl));
  }

  void _stopSound() {
    _player.stop();
  }

  //This function like config but update time
  //Find mode present and set remaining time
  void _updateRemainingTime() {
    // Update remaining time based on current mode
    Mode currentMode = _getModeById(_modeNow)!;
    setState(() {
      _remainingTime = currentMode.values;
    });
  }

  Mode? _getModeById(int id) {
    switch (id) {
      case 1:
        return _pomodoro;
      case 2:
        return _shortBreak;
      case 3:
        return _longBreak;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Pomodoro Timer'),
        ),
        actions: [
          userProvider.user == null
              ? IconButton(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 40,
                  ),
                  iconSize: 50,
                  icon: Icon(Icons.person_outline_rounded),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text(userProvider.user!.name), // Display user's name
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          userProvider.logout(); // Call logout method
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
              color: _modeNow == 1
                  ? Colors.red.shade200
                  : _modeNow == 2
                      ? Colors.blue.shade200
                      : Colors.green.shade200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(_pomodoro, isSelected: _modeNow == 1),
                        SizedBox(width: 10),
                        _buildButton(_shortBreak, isSelected: _modeNow == 2),
                        SizedBox(width: 10),
                        _buildButton(_longBreak, isSelected: _modeNow == 3),
                      ],
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<int>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text(
                              '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 80,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (_completedCycles > 0)
                              Text(
                                'Completed cycles: $_completedCycles',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    _isWorking
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isWorking = false;
                              });
                              _startTimer();
                            },
                            child: Text('Stop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isWorking = true;
                              });
                              _startTimer();
                            },
                            child: Text('Start'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _resetTimer,
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                        ),
                        if (!_isWorking)
                          IconButton(
                            onPressed: _configureDurations,
                            icon: Icon(Icons.settings),
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white, // Replace with your desired background color
              child: TodoListWidget(), // Replace with your ToDoList widget
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(Mode mode, {bool isSelected = false}) {
    return ElevatedButton(
      onPressed: _isWorking
          ? () {}
          : () {
              setState(() {
                _modeNow = mode.id;
                _updateRemainingTime();
              });
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.red : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        mode.name,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

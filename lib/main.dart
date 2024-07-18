import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/Model/mode.dart';
import 'package:pomodoro/Model/user.dart';
import 'package:pomodoro/Screens/pomodoro_screen.dart';
import 'package:pomodoro/Widget/ToDoList.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pomodoro Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PomodoroScreen(),
      ),
    ),
  );
}

// void main() {
//   runApp(ChangeNotifierProvider(
//       create: (context) => UserProvider(), child: PomodoroApp()));
// }

// class PomodoroApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Pomodoro Timer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PomodoroScreen(),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> _login(BuildContext context) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     final url = Uri.parse('https://clinic-flask.onrender.com/login');
//     try {
//       final response = await http.post(
//         url,
//         body: {
//           'username': _usernameController.text,
//           'password': _passwordController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         // Successful login
//         User userLogin = User(id: 1, name: "Temp");
//         userProvider.setUser(userLogin);
//         print(userProvider.user);
//         User? test = userProvider.user;
//         print(test?.name);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => PomodoroScreen()),
//         );
//       } else {
//         // Handle other status codes (e.g., 401 for unauthorized)
//         print('Failed to login: ${response.statusCode}');
//         // Handle error UI or show a message to the user
//       }
//     } catch (e) {
//       // Handle network errors or other exceptions
//       print('Error during login: $e');
//       // Show error UI or message to the user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _login(context),
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PomodoroScreen extends StatefulWidget {
//   @override
//   _PomodoroScreenState createState() => _PomodoroScreenState();
// }

// class _PomodoroScreenState extends State<PomodoroScreen> {
//   Mode _pomodoro = Mode(id: 1, name: "Pomodoro");
//   Mode _shortBreak = Mode(id: 2, name: "Short break");
//   Mode _longBreak = Mode(id: 3, name: "Long break");
//   final _player = AudioPlayer();

//   late String token;
//   // Default to Pomodoro mode
//   // To know what's mode of the timer now
//   int _modeNow = 1;

//   static const oneSecond = Duration(seconds: 1);
//   static const int _cyclesUntilLongBreak = 4;

//   int selectedOption = 1;
//   bool _isWorking = false;
//   int _remainingTime = 0;
//   int _completedCycles = 0;

//   Timer? _timer;
//   late StreamController<int> _streamController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _streamController = StreamController<int>.broadcast();
//     checkConfig();
//   }

//   @override
//   void dispose() {
//     _streamController.close();
//     super.dispose();
//   }

//   void _initializeNotifications() {
//     // TODO: Initialize FlutterLocalNotificationsPlugin
//   }

//   void _startTimer() {
//     // TODO: Implement the logic to start the timer
//     // Start the timer based on the selected mode (Pomodoro, Short Break, or Long Break).
//     // Use a timer or a periodic function to update the remaining time and trigger
//     // the appropriate actions when each interval is completed.
//     if (_isWorking) {
//       _timer = Timer.periodic(oneSecond, (timer) {
//         setState(() {
//           if (_remainingTime <= 0) {
//             timer.cancel();
//             _showNotification(_getModeById(_modeNow)!.name, "Time's up!");
//             _playSound();
//           } else {
//             _streamController.add(--_remainingTime);
//           }
//         });
//       });
//     } else {
//       _timer?.cancel();
//     }
//   }

//   void _resetTimer() {
//     // TODO: Implement the logic to reset the timer
//     // Reset the timer to its initial state, clearing any ongoing intervals and
//     // resetting the completed cycles count.
//   }

//   void _configureDurations() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController pomodoroController = TextEditingController();
//         TextEditingController shortBreakController = TextEditingController();
//         TextEditingController longBreakController = TextEditingController();

//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Configure Durations'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ListTile(
//                       title: Text(
//                         'Baby step',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('10 min  •  5 min  •  10 min'),
//                       leading: Radio<int>(
//                         value: 1,
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value!;
//                             checkConfig();
//                           });
//                         },
//                       ),
//                     ),
//                     ListTile(
//                       title: Text(
//                         'Popular',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('20 min  •  5 min  •  15 min'),
//                       leading: Radio<int>(
//                         value: 2,
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value!;
//                             checkConfig();
//                           });
//                         },
//                       ),
//                     ),
//                     ListTile(
//                       title: Text(
//                         'Medium',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('40 min  •  8 min  •  20 min'),
//                       leading: Radio<int>(
//                         value: 3,
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value!;
//                             checkConfig();
//                           });
//                         },
//                       ),
//                     ),
//                     ListTile(
//                       title: Text(
//                         'Extended',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('60 min  •  10 min  •  25 min'),
//                       leading: Radio<int>(
//                         value: 4,
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value!;
//                             checkConfig();
//                           });
//                         },
//                       ),
//                     ),
//                     ListTile(
//                       title: Text(
//                         'Custom',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('Custom your duration'),
//                       leading: Radio<int>(
//                         value: 5,
//                         groupValue: selectedOption,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedOption = value!;
//                             checkConfig();
//                           });
//                         },
//                       ),
//                     ),
//                     if (selectedOption == 5) ...[
//                       TextField(
//                         controller: pomodoroController,
//                         decoration: InputDecoration(
//                           labelText: 'Pomodoro duration (min)',
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           // Cập nhật giá trị pomodoro
//                           _pomodoro.values =
//                               int.tryParse(value) ?? _pomodoro.values;
//                         },
//                       ),
//                       TextField(
//                         controller: shortBreakController,
//                         decoration: InputDecoration(
//                           labelText: 'Short break duration (min)',
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           // Cập nhật giá trị short break
//                           _shortBreak.values =
//                               int.tryParse(value) ?? _shortBreak.values;
//                         },
//                       ),
//                       TextField(
//                         controller: longBreakController,
//                         decoration: InputDecoration(
//                           labelText: 'Long break duration (min)',
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           // Cập nhật giá trị long break
//                           _longBreak.values =
//                               int.tryParse(value) ?? _longBreak.values;
//                         },
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Close'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showNotification(String title, String body) {
//     // TODO: Implement the logic to show a local notification
//     // Display a local notification when each interval is completed, informing
//     // the user about the end of the Pomodoro, Short Break, or Long Break.
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => AlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Close'),
//             onPressed: () {
//               _stopSound();
//               Navigator.of(context).pop();
//               setState(() {
//                 if (_modeNow == 1) _completedCycles++;
//                 _completedCycles == _cyclesUntilLongBreak
//                     ? (_modeNow = 3, _completedCycles = 1)
//                     : (_modeNow == 1 ? _modeNow = 2 : _modeNow = 1);

//                 _updateRemainingTime();
//                 _startTimer();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void checkConfig() {
//     print("Checking");
//     print(selectedOption);
//     print("Checking22");
//     print(_pomodoro.values);
//     print(_pomodoro.name);
//     print(_pomodoro.values);
//     switch (selectedOption) {
//       case 1:
//         setState(() {
//           _pomodoro.values = 10;
//           _shortBreak.values = 5;
//           _longBreak.values = 10;
//           _updateRemainingTime();
//         });
//         break;
//       case 2:
//         setState(() {
//           _pomodoro.values = 20;
//           _shortBreak.values = 5;
//           _longBreak.values = 15;
//           _updateRemainingTime();
//         });
//         break;
//       case 3:
//         setState(() {
//           _pomodoro.values = 30;
//           _shortBreak.values = 8;
//           _longBreak.values = 20;
//           _updateRemainingTime();
//         });
//         break;
//       case 4:
//         setState(() {
//           _pomodoro.values = 60;
//           _shortBreak.values = 10;
//           _longBreak.values = 25;
//           _updateRemainingTime();
//         });
//         break;
//       case 5:
//         setState(() {
//           _updateRemainingTime();
//         });
//     }
//   }

//   void _playSound() {
//     String soundUrl =
//         'https://assets.mixkit.co/active_storage/sfx/603/603-preview.mp3';

//     _player.play(UrlSource(soundUrl));
//   }

//   void _stopSound() {
//     _player.stop();
//   }

//   void _updateRemainingTime() {
//     // Update remaining time based on current mode
//     Mode currentMode = _getModeById(_modeNow)!;
//     setState(() {
//       _remainingTime = currentMode.values;
//     });
//   }

//   Mode? _getModeById(int id) {
//     switch (id) {
//       case 1:
//         return _pomodoro;
//       case 2:
//         return _shortBreak;
//       case 3:
//         return _longBreak;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pomodoro Timer'),
//         actions: [
//           userProvider.user == null
//               ? IconButton(
//                   padding: const EdgeInsetsDirectional.symmetric(
//                     horizontal: 40,
//                   ),
//                   iconSize: 50,
//                   icon: Icon(Icons.person_outline_rounded),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                     );
//                   },
//                 )
//               : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Icon(Icons.person),
//                       SizedBox(width: 8),
//                       Text(userProvider.user!.name), // Display user's name
//                       SizedBox(width: 16),
//                       TextButton(
//                         onPressed: () {
//                           userProvider.logout(); // Call logout method
//                         },
//                         child: Text('Logout'),
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Container(
//               padding: const EdgeInsetsDirectional.symmetric(
//                 horizontal: 40,
//                 vertical: 100,
//               ),
//               color: _modeNow == 1
//                   ? Colors.red.shade200
//                   : _modeNow == 2
//                       ? Colors.blue.shade200
//                       : Colors.green.shade200,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _buildButton(_pomodoro, isSelected: _modeNow == 1),
//                         SizedBox(width: 10),
//                         _buildButton(_shortBreak, isSelected: _modeNow == 2),
//                         SizedBox(width: 10),
//                         _buildButton(_longBreak, isSelected: _modeNow == 3),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     StreamBuilder<int>(
//                       stream: _streamController.stream,
//                       builder: (context, snapshot) {
//                         return Text(
//                           '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
//                           style: TextStyle(
//                             fontSize: 80,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     _isWorking
//                         ? ElevatedButton(
//                             onPressed: () => {
//                               setState(() {
//                                 _isWorking = false;
//                               }),
//                               _startTimer(),
//                             },
//                             child: Text('Stop'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           )
//                         : ElevatedButton(
//                             onPressed: () => {
//                               setState(() {
//                                 _isWorking = true;
//                               }),
//                               _startTimer(),
//                             },
//                             child: Text('Start'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: _resetTimer,
//                           icon: Icon(Icons.refresh),
//                           color: Colors.white,
//                         ),
//                         if (!_isWorking)
//                           IconButton(
//                             onPressed: _configureDurations,
//                             icon: Icon(Icons.settings),
//                             color: Colors.white,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//               width: 20), // Add spacing between main content and To-Do List
//           Container(
//             width: 300, // Adjust the width as needed
//             child: TodoListWidget(), // Add the To-Do List widget here
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildButton(Mode mode, {bool isSelected = false}) {
//     return ElevatedButton(
//       onPressed: _isWorking
//           ? () {}
//           : () {
//               setState(() {
//                 _modeNow = mode.id;
//                 _updateRemainingTime();
//               });
//             },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? Colors.red : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       child: Text(
//         mode.name,
//         style: TextStyle(color: isSelected ? Colors.white : Colors.black),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'login_screen.dart';

// // void main() {
// //   runApp(PomodoroApp());
// // }

// // class PomodoroApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Pomodoro Timer',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: PomodoroApp(),
// //     );
// //   }
// // }

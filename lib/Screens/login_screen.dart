import 'package:flutter/material.dart';
import 'package:pomodoro/Model/user.dart';
import 'package:provider/provider.dart';
import 'pomodoro_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Extend test call api from backend then process and created provider User
  Future<void> _login(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    //Demo backend so we must wait =))) Long time dont use when call it will be builded again
    final url = Uri.parse('https://clinic-flask.onrender.com/login');
    try {
      final response = await http.post(
        url,
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      //Create tempo User to log in
      if (response.statusCode == 200) {
        User userLogin = User(id: 1, name: "Temp");
        userProvider.setUser(userLogin);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PomodoroScreen()),
        );
      } else {
        print('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 100, horizontal: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

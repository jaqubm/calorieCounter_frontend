import 'package:caloriecounter/screens/login_screen.dart';
import 'package:caloriecounter/services/auth_service.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Profile Information'),
            SizedBox(height: 20),
            
            GestureDetector(
              onTap: () async {
                await _authService.handleSignOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                children: [
                  Icon(Icons.logout, size: 40, color: Colors.red),
                  Text('Log Out', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
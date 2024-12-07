import 'package:caloriecounter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:caloriecounter/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user != null && user.photoUrl != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoUrl!),
                  )
                : Icon(Icons.account_circle, size: 100),
            SizedBox(height: 20),
            Text(user?.displayName ?? 'Unknown User'),
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

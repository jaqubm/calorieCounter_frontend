import 'package:caloriecounter/colors.dart';
import 'package:caloriecounter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(CalorieCounterApp());
}

class CalorieCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        home: StartScreen(),
    );
  }
  
}

class StartScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(
              height: 89,
              width: 269,
              child:  Image.asset('assets/logo.png'),
            ),

            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                _apiService.checkConnection();
                
                await _authService.handleSignOut();
                final idToken = await _authService.signInWithGoogle();
                if (idToken != null) {
                  await _authService.sendTokenToBackend(idToken);
                }
                else{
                  print("NIE UDALO SIE");
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Ustawienie promienia zaokrąglenia
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child:  Image.asset('assets/google-icon.png'),
                    ),
                    
                  ),
                  
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: Text('Sign in with Google'),
                  )
                  
                ]
              ) 
            ),
          ],
        ),
      ),
    );
  }
}
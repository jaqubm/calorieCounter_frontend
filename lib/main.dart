import 'package:caloriecounter/colors.dart';
import 'package:flutter/material.dart';

void main() {
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
              onPressed: () {

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
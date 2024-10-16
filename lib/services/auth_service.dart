import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final GoogleSignIn _googleSignIn;
  final backendUrl = dotenv.env['BACKEND_URL']!; 

  AuthService(): _googleSignIn = GoogleSignIn(
          clientId: dotenv.env['GOOGLE_CLIENT_DEV_KEY']!,
          scopes: [
            'https://www.googleapis.com/auth/userinfo.email',
            'openid',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        );


  Future<String?> signInWithGoogle() async {
    final GOOGLE_CLIENT_DEV_KEY = dotenv.env['GOOGLE_CLIENT_DEV_KEY']!;

    final GoogleSignIn _googleSignIn = new GoogleSignIn(
      clientId: GOOGLE_CLIENT_DEV_KEY,
      scopes: [
        'https://www.googleapis.com/auth/userinfo.email',
        'openid',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );
    try {
      final googleUserAccount = await _googleSignIn.signIn();
      final googleAuth = await googleUserAccount?.authentication;
      if (googleAuth != null) {
        return googleAuth.idToken;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> sendTokenToBackend(String idToken) async {
    final response = await http.post(
      Uri.parse(backendUrl + "/User/SignIn"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(idToken),
    );

    if (response.statusCode == 200) {
      print('Login success');
    } else {
      print('Login error: ${response.body}');
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      print("Successfully signed out.");
    } catch (error) {
      print("Sign out error: $error");
    }
  }
}

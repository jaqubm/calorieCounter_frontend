import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal()
      : _googleSignIn = GoogleSignIn(
          clientId: dotenv.env['GOOGLE_CLIENT_DEV_KEY']!,
          scopes: [
            'https://www.googleapis.com/auth/userinfo.email',
            'openid',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        );

  final GoogleSignIn _googleSignIn;
  final String backendUrl = dotenv.env['BACKEND_URL']!;
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<String?> signInWithGoogle() async {
    try {
      _user = await _googleSignIn.signIn();
      final googleAuth = await _user?.authentication;
      if (googleAuth != null) {
        String? idToken = googleAuth.idToken;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('idToken', idToken!);
        await prefs.setString('email', _user?.email ?? "");
        return idToken;
      }
    } catch (error) {
      print("Login error: $error");
    }
    return null;
  }

  Future<void> sendTokenToBackend(String idToken) async {
    final response = await http.post(
      Uri.parse('$backendUrl/Auth/SignIn'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
    );

    if (response.statusCode == 200) {
      print('Login success');
    } else {
      print('Login error: ${response.statusCode}');
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      _user = null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('idToken');

      print("Successfully signed out.");
    } catch (error) {
      print("Sign out error: $error");
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }
}

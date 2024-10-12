import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final testUrl = dotenv.env['BACKEND_URL']! + "/Api/Status";

  Future<void> checkConnection() async {
    try {
      final response = await http.get(Uri.parse(testUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['apiStatus'] == 'OK' && data['databaseConnectionStatus'] == 'OK') {
          print('Połączenie z API i bazą danych jest prawidłowe.');
        } else {
          print('Problem z połączeniem: ${data['apiStatus']}, ${data['databaseConnectionStatus']}');
        }
      } else {
        print('Błąd serwera: ${response.statusCode}');
      }
    } catch (e) {
      print('Wystąpił błąd połączenia: $e');
    }
  }
}

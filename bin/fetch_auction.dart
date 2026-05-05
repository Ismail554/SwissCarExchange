import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://doleritic-goutily-shila.ngrok-free.dev/api/auctions/2/');
  final response = await http.get(url);
  print(response.body);
}

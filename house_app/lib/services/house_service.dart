import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> postLogin(String username, String password) async {
  var url = "http://192.168.0.102:5001/login";

  final Map<String, String> data = {"username": username, "password": password};

  var headers = {"Content-Type": "application/json"};

  var response = await http.post(Uri.parse(url),
      headers: headers, body: json.encode(data));

  return response;
}

Future<http.Response> getDoorState(String door) async {
  var url = "http://192.168.0.102:5001/home/get_door_state";

  final Map<String, String> data = {"door": door};

  var headers = {"Content-Type": "application/json"};

  var response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(data),
  );

  return response;
}

Future<http.Response> changeLightState(String room, int state) async {
  var url = "http://192.168.0.102:5001/home/change_light_state";

  final Map<String, dynamic> data = {"room": room, "state": state};

  var headers = {"Content-Type": "application/json"};

  var response = await http.post(Uri.parse(url),
      headers: headers, body: json.encode(data));

  return response;
}

Future<http.Response> getLightState(String room) async {
  var url = "http://192.168.0.102:5001/home/get_light_state";

  final Map<String, dynamic> data = {"room": room};

  var headers = {"Content-Type": "application/json"};

  var response = await http.post(Uri.parse(url),
      headers: headers, body: json.encode(data));

  return response;
}

Future<http.Response> takePhoto() async {
  var url = "http://192.168.0.102:5001/home/take_photo";

  var headers = {"Content-Type": "application/json"};

  var response = await http.get(Uri.parse(url), headers: headers);

  return response;
}

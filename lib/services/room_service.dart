import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/room_model.dart';

class RoomService {
  static const String baseUrl = 'https://bxmgxsx0-8000.inc1.devtunnels.ms';

  Future<List<Room>> getRooms() async {
    final response =
        await http.get(Uri.parse('$baseUrl/college/get_all_rooms'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms: ${response.statusCode}');
    }
  }
}

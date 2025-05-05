import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/room_model.dart';

class RoomService {
  Future<List<Room>> getRooms() async {
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/college/get_all_rooms'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms: ${response.statusCode}');
    }
  }
}

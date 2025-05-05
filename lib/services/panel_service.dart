import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/panel_model.dart';

class PanelService {
  Future<List<Panel>> getPanels() async {
    print(
        'Calling API: ${ApiConstants.baseUrl}/panels/get_all_panels'); // Debug
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/panels/get_all_panels'));
    print('API response: ${response.statusCode} - ${response.body}'); // Debug
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final panels = data.map((json) => Panel.fromJson(json)).toList();
      print(
          'Panels fetched: ${panels.map((p) => p.panelLetter).toList()}'); // Debug
      return panels;
    } else {
      throw Exception(
          'Failed to load panels: ${response.statusCode} - ${response.body}');
    }
  }
}

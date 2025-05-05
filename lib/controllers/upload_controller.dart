import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UploadController {
  final ApiService _apiService = ApiService();

  Future<void> uploadImage(
      BuildContext context, File image, String studentId) async {
    try {
      final response = await _apiService.uploadStudentFace(
        studentId: studentId,
        imageFile: image,
      );

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful!')),
        );
        print(respStr);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload failed with status ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}

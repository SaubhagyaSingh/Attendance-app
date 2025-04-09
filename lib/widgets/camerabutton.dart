import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraButton extends StatefulWidget {
  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  File? _image;

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera_alt),
          label: Text("Open Camera"),
        ),
        SizedBox(height: 20),
        _image != null
            ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
            : Text("No image captured."),
      ],
    );
  }
}

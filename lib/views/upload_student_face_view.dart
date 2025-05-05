import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../controllers/upload_controller.dart';

class UploadStudentFaceView extends StatefulWidget {
  final String studentId;
  final CameraDescription camera;

  const UploadStudentFaceView(
      {super.key, required this.studentId, required this.camera});

  @override
  _UploadStudentFaceViewState createState() => _UploadStudentFaceViewState();
}

class _UploadStudentFaceViewState extends State<UploadStudentFaceView> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final UploadController _uploadController = UploadController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _takePicture() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreenEMG(camera: widget.camera),
      ),
    );
    if (result != null) {
      setState(() => _selectedImage = File(result));
    }
  }

  void _uploadImage() {
    if (_selectedImage != null) {
      _uploadController.uploadImage(context, _selectedImage!, widget.studentId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select or capture an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Student Face')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : Text('No image selected.'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _pickImage, child: Text('Pick from Gallery')),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _takePicture, child: Text('Take Picture')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _uploadImage, child: Text('Upload Image')),
          ],
        ),
      ),
    );
  }
}

class TakePictureScreenEMG extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreenEMG({super.key, required this.camera});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreenEMG> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Navigator.pop(context, image.path);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

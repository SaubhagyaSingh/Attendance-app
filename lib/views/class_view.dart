import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../services/class_photo_service.dart';

class ClassView extends StatefulWidget {
  final CameraDescription camera;

  const ClassView({super.key, required this.camera});

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  final RoomService _roomService = RoomService();
  final ClassPhotoService _classPhotoService = ClassPhotoService();
  final _formKey = GlobalKey<FormState>();
  List<Room> _rooms = [];
  Room? _selectedRoom;
  bool _isLoading = false;
  String? _date;
  String? _time;
  File? _image;

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() => _isLoading = true);
    try {
      final rooms = await _roomService.getRooms();
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching rooms: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching rooms: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _selectedRoom != null) {
      setState(() => _isLoading = true);
      try {
        final response = await _classPhotoService.uploadClassPhoto(
          roomId: _selectedRoom!.id,
          date: _date!,
          time: _time!,
          imagePath: _image!.path,
        );
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class photo uploaded successfully')),
        );
        // Clear form
        _formKey.currentState!.reset();
        _dateController.clear();
        _timeController.clear();
        setState(() {
          _selectedRoom = null;
          _image = null;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading class photo: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all fields and select an image')),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Class Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Room>(
                      decoration:
                          const InputDecoration(labelText: 'Select Room'),
                      value: _selectedRoom,
                      isExpanded: true,
                      items: _rooms.map((Room room) {
                        return DropdownMenuItem<Room>(
                          value: room,
                          child: Text(room.name),
                        );
                      }).toList(),
                      onChanged: (Room? newValue) {
                        setState(() {
                          _selectedRoom = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a room' : null,
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  // Basic date format validation
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Enter date in YYYY-MM-DD format';
                  }
                  return null;
                },
                onChanged: (value) => _date = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  // Basic time format validation
                  final regex = RegExp(r'^\d{2}:\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Enter time in HH:MM format';
                  }
                  return null;
                },
                onChanged: (value) => _time = value,
              ),
              const SizedBox(height: 16),
              _image == null
                  ? const Text('No image selected')
                  : Image.file(_image!, height: 100),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Capture Photo'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Upload Class Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

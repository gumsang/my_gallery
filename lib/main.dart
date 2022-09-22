import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreatePage(),
    );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _image = [];
  Timer? timer;
  int _currentIndex = 0;

  @override
  void dispose() {
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildbody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            selectImages();
          },
          icon: const Icon(Icons.add_a_photo),
        ),
        IconButton(
          onPressed: () {
            addImages();
          },
          icon: const Icon(Icons.add_box_outlined),
        )
      ],
    );
  }

  _buildbody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _image == null ? const Text('No Image') : Image.file(_image!),
          _image.isEmpty
              ? const Text('No Image')
              : GestureDetector(
                  onHorizontalDragEnd: (dragEndDetails) {
                    if (dragEndDetails.primaryVelocity! < 0) {
                      // Page forwards

                      _goForward();
                    } else if (dragEndDetails.primaryVelocity! > 0) {
                      // Page backwards

                      _goBack();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.file(
                      File(_image[_currentIndex].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future selectImages() async {
    final List<XFile>? image = await _picker.pickMultiImage();
    if (image != null) {
      setState(() {
        _currentIndex = 0;
        _image.clear();
        _image.addAll(image);
      });
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 3), ((timer) {
        if (_image.isNotEmpty && _currentIndex == _image.length - 1) {
          setState(() {
            _currentIndex = 0;
          });
        } else if (_image.isEmpty) {
          _currentIndex = 0;
        } else {
          setState(() {
            _currentIndex++;
          });
        }
      }));
    }
  }

  void setTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), ((timer) {
      if (_image.isNotEmpty && _currentIndex == _image.length - 1) {
        setState(() {
          _currentIndex = 0;
        });
      } else if (_image.isEmpty) {
        _currentIndex = 0;
      } else {
        setState(() {
          _currentIndex++;
        });
      }
    }));
  }

  Future addImages() async {
    final List<XFile>? image = await _picker.pickMultiImage();
    if (image != null) {
      setState(() {
        _currentIndex = 0;
        _image.addAll(image);
      });
      setTimer();
    }
  }

  void _goForward() {
    setState(() {
      if (_currentIndex == _image.length - 1) {
        _currentIndex = 0;
      } else {
        _currentIndex++;
      }
    });
    setTimer();
  }

  void _goBack() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = _image.length - 1;
      } else {
        _currentIndex--;
      }
    });
    setTimer();
  }
}

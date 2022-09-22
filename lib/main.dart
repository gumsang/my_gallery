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
  // The index starts at 0 and is set to 1 because of additions
  final int _currentIndex = 1;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImages();
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send),
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
              : GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _image.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(_image[index].path),
                        fit: BoxFit.cover);
                  })
        ],
      ),
    );
  }

  Future selectImages() async {
    final List<XFile>? image = await _picker.pickMultiImage();
    if (image!.isNotEmpty) {
      setState(() {
        _image.addAll(image);
      });
    }
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;

import 'progress_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _showProgress = false;
  Uint8List? _image;
  Uint8List? _originalImage;

  void _loadImage(String? path) {
    if (path == null) return;

    setState(() {
      _showProgress = true;
    });
    final image = File(path).readAsBytesSync();
    setState(() {
      _image = image;
      _originalImage = image;
      _showProgress = false;
    });
  }

  static Uint8List _applySepiaFilter(Uint8List original) {
    final decoded = image.decodeImage(original.toList())!;
    final sepia = image.sepia(decoded);
    final encoded = Uint8List.fromList(image.encodeJpg(sepia));
    return encoded;
  }

  void _applySepia() {
    setState(() {
      _showProgress = true;
    });
    final image = _applySepiaFilter(_image!);
    setState(() {
      _image = image;
      _showProgress = false;
    });
  }

  void _showImagePicker() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    _loadImage(result?.files.single.path);
  }

  void _undo() {
    setState(() {
      _image = _originalImage;
    });
  }

  void _clear() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing Demo'),
      ),
      body: Stack(
        children: [
          if (_image != null)
            Center(
              child: Image.memory(_image!, gaplessPlayback: true),
            ),
          ProgressWidget(show: _showProgress),
        ],
      ),
      persistentFooterButtons: <Widget>[
        TextButton(
          onPressed: !_showProgress && _image == null ? _showImagePicker : null,
          child: const Text('Load'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != null ? _applySepia : null,
          child: const Text('Sepia'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != _originalImage ? _undo : null,
          child: const Text('Undo'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != null ? _clear : null,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}

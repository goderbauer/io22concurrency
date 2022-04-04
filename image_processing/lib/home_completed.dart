import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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

  void _loadImageSync(String? path) {
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

  Future<void> _loadImageAsync(String? path) async {
    if (path == null) return;

    setState(() {
      _showProgress = true;
    });
    final image = await File(path).readAsBytes();
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

  void _applySepiaSync() {
    setState(() {
      _showProgress = true;
    });
    final image = _applySepiaFilter(_image!);
    setState(() {
      _image = image;
      _showProgress = false;
    });
  }

  void _applySepiaAsync() async {
    setState(() {
      _showProgress = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final image = _applySepiaFilter(_image!);
    setState(() {
      _image = image;
      _showProgress = false;
    });
  }

  void _applySepiaInIsolate() async {
    setState(() {
      _showProgress = true;
    });
    final image = await compute(_applySepiaFilter, _image!);
    setState(() {
      _image = image;
      _showProgress = false;
    });
  }

  void _showImagePicker({@required sync}) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (sync) {
      _loadImageSync(result?.files.single.path);
    } else {
      _loadImageAsync(result?.files.single.path);
    }
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
          onPressed: !_showProgress && _image == null
              ? (() {
                  _showImagePicker(sync: true);
                })
              : null,
          child: const Text('Load (sync)'),
        ),
        TextButton(
          onPressed: !_showProgress && _image == null
              ? (() {
                  _showImagePicker(sync: false);
                })
              : null,
          child: const Text('Load (async)'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != null ? _applySepiaSync : null,
          child: const Text('Sepia (sync)'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != null ? _applySepiaAsync : null,
          child: const Text('Sepia (async)'),
        ),
        TextButton(
          onPressed:
              !_showProgress && _image != null ? _applySepiaInIsolate : null,
          child: const Text('Sepia (isolate)'),
        ),
        TextButton(
          onPressed: !_showProgress && _image != null ? _undo : null,
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

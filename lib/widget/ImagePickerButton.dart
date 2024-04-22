import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerButton({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File? _imageFile;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_imageFile!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _getImage,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.grey.withOpacity(0.5),
        child: _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.cover)
            : Icon(Icons.add, size: 50, color: Colors.white),
      ),
    );
  }
}

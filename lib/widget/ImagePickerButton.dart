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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        width: 200,
        height: 200,
        //color: Colors.black.withOpacity(0.8),
        child: _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.contain)
            : Icon(Icons.add, size: 50, color: Colors.white),
      ),
    );
  }
}

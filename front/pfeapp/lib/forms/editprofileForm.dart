import 'package:flutter/material.dart';
import 'package:pfeapp/API/editprofileAPI.dart';
import 'package:pfeapp/Mainpage/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditProfileWidget extends StatefulWidget {
  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final TextEditingController usernameController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _editProfile() async {
            try {
              String username = usernameController.text;
              File? picture = _image;
              EditProfileAPI api = EditProfileAPI();
              await api.editProfile(username, picture);
              print("success");
            } catch (e) {
              // Handle errors, show error message or toast
              print('Error: $e');
            }
  }

  Future<void> _getImage() async {
          final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {
            if (pickedFile != null) {
              _image = File(pickedFile.path);
            } else {
              print('No image selected.');
            }
          });
  }
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Edit Profile'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            const SizedBox(height: 20),
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: 200,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Picture'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editProfile,
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
               onPressed: () {
                     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileWidget()),
            );
                  },
              child: const Text('Cancel Changes'),
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
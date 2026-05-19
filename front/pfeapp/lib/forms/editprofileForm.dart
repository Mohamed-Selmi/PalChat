import 'package:flutter/material.dart';
import 'package:pfeapp/API/editprofileAPI.dart';
import 'package:pfeapp/Mainpage/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pfeapp/API/UserAPI.dart';
import 'package:pfeapp/models/user.dart';

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
               if (username.isEmpty) {
   
                      User? currentUser = await UserAPI.fetchUser();
                      if (currentUser != null) {
                        username = currentUser.username;
                      } else {
                        throw Exception('Failed to fetch current user');
                      }
                    }
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
     backgroundColor: const Color(0xfff2f2f2),
    appBar: AppBar(
       backgroundColor: const Color(0xfff2f2f2),
      title: const Text('Edit Profile'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
              SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
            _image != null
                ? Image.file(
                    _image!,
                    height:  MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.cover,
                  )
                :  Placeholder(
                    fallbackHeight:  MediaQuery.of(context).size.height * 0.4,
                    fallbackWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                   SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                  SizedBox(height:MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                     
                      child:TextField(
                      
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      style: const TextStyle(color: Color(0xff011c27),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter a new Username',
                        prefixIcon: Icon(Icons.person,
                        color: Color((0xff011c27)),),
                        filled: true,
                        fillColor: Color(0xfff5e1da),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
 SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
             SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                 _getImage();
                                  },
                                  child:const Text("Select picture",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color:  Color(0xff011c27)
                                  ),
                                  ),
                    ),
                    ),
 SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
            SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                 _editProfile();
                                  },
                                  child:const Text("Save changes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color:  Color(0xff011c27)
                                  ),
                                  ),
                    ),
                    ),
 SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
            SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                     onPressed: () {
                     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileWidget()),
            );
                  },
                                  child:const Text("Cancel changes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color:  Color(0xff011c27)
                                  ),
                                  ),
                    ),
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
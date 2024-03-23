import 'package:flutter/material.dart';
import 'package:pfeapp/API/editprofileAPI.dart';
import 'package:pfeapp/Mainpage/profile.dart';
class EditProfileForm extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController pictureUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: pictureUrlController,
            decoration: const InputDecoration(
              labelText: 'Picture URL',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
          onPressed: () async {
                              String username = usernameController.text.trim();
                              String pictureUrl = pictureUrlController.text.trim();
                              if (username.isNotEmpty && pictureUrl.isNotEmpty) {
                                try {
                                  EditProfileAPI editProfileAPI = EditProfileAPI();
                                  await editProfileAPI.editProfile(username, pictureUrl);
                                  print('Profile updated successfully');
                                  // Optionally, you can navigate back to the profile page
                                  Navigator.pop(context); // This will pop the current route (EditProfileForm) from the stack
                                } catch (e) {
                                  print('Failed to update profile: $e');
                                }
                              } else {
                                // Handle empty fields
                                print('Please fill all fields');
                              }
                            },

            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
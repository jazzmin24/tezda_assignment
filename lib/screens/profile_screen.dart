import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_assignment/auth/registration_screen.dart';
import 'package:tezda_assignment/config/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _profileImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      // Load profile image URL if available
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _profileImageUrl = userDoc.data()?['profileImage'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: _nameController.text);
        await user.updateEmail(_emailController.text);

        // Optionally update profile image in Firebase Storage and Firestore
        if (_profileImageUrl.isNotEmpty) {
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          await userDoc.update({
            'name': _nameController.text,
            'email': _emailController.text,
            'profileImage': _profileImageUrl
          });
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Updated')));
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update profile')));
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path); // Convert path to File
      final ref = FirebaseStorage.instance.ref().child(
          'profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg');

      try {
        await ref.putFile(file); // Use the File object here
        final url = await ref.getDownloadURL();

        setState(() {
          _profileImageUrl = url;
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image')));
      }
    }
  }

  Future<void> _showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutConfirmation, // Show confirmation dialog
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w), // Use ScreenUtil for responsive padding
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50.r, // Use ScreenUtil for responsive radius
                backgroundImage: _profileImageUrl.isNotEmpty
                    ? NetworkImage(_profileImageUrl)
                    : null,
                child:
                    _profileImageUrl.isEmpty ? Icon(Icons.add_a_photo, size: 24.sp) : null,
              ),
            ),
            SizedBox(height: 20.h), // Use ScreenUtil for responsive spacing
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  SizedBox(height: 12.h), // Use ScreenUtil for responsive spacing
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                    ),
                    validator: (value) => value!.isEmpty || !value.contains('@')
                        ? 'Please enter a valid email'
                        : null,
                  ),
                  SizedBox(height: 20.h), // Use ScreenUtil for responsive spacing
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: appbarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 16.sp), // Use ScreenUtil for responsive font size
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tezda_assignment/auth/registration_screen.dart';
// import 'package:tezda_assignment/config/colors.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   String _profileImageUrl = '';
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _nameController.text = user.displayName ?? '';
//       _emailController.text = user.email ?? '';
//       // Load profile image URL if available
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//       setState(() {
//         _profileImageUrl = userDoc.data()?['profileImage'] ?? '';
//       });
//     }
//   }

//   // Future<void> _updateProfile() async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user != null) {
//   //     try {
//   //       await user.updateProfile(displayName: _nameController.text);
//   //       await user.updateEmail(_emailController.text);
//   //       // Optionally update profile image in Firebase Storage and Firestore
//   //       if (_profileImageUrl.isNotEmpty) {
//   //         final userDoc =
//   //             FirebaseFirestore.instance.collection('users').doc(user.uid);
//   //         await userDoc.update({
//   //           'name': _nameController.text,
//   //           'email': _emailController.text,
//   //           'profileImage': _profileImageUrl
//   //         });
//   //       }
//   //       ScaffoldMessenger.of(context)
//   //           .showSnackBar(SnackBar(content: Text('Profile Updated')));
//   //     } catch (e) {
//   //       print('Error updating profile: $e');
//   //       ScaffoldMessenger.of(context)
//   //           .showSnackBar(SnackBar(content: Text('Failed to update profile')));
//   //     }
//   //   }
//   // }

// //  Future<void> _pickImage() async {
// //   final XFile? pickedFile =
// //       await _picker.pickImage(source: ImageSource.gallery);
// //   if (pickedFile != null) {
// //     final File file = File(pickedFile.path); // Convert path to File
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       final userId = user.uid;
// //       print('User ID: $userId'); // Debug print to check user ID
// //       final ref = FirebaseStorage.instance.ref().child(
// //           'profile_images/$userId.jpg');
// //       try {
// //         await ref.putFile(file); // Use the File object here
// //         final url = await ref.getDownloadURL();
// //         setState(() {
// //           _profileImageUrl = url;
// //         });
// //       } catch (e) {
// //         print('Error uploading image: $e');
// //         ScaffoldMessenger.of(context)
// //             .showSnackBar(SnackBar(content: Text('Failed to upload image')));
// //       }
// //     } else {
// //       print('No user is currently signed in');
// //     }
// //   }
// // }

//   Future<void> _showLogoutConfirmation() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           surfaceTintColor: Colors.transparent,
//           title: Text(
//             'Confirm Logout',
//             style: TextStyle(color: appbarColor),
//           ),
//           content: Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text(
//                 'Cancel',
//                 style:
//                     TextStyle(color: appbarColor, fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text(
//                 'Log Out',
//                 style:
//                     TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
//               ),
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => RegistrationScreen()),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldColor,
//       appBar: AppBar(
//         backgroundColor: appbarColor,
//         title: Text('Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _showLogoutConfirmation,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),
//             GestureDetector(
//               onTap: () {},
//               //_pickImage,
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 50.r,
//                 backgroundImage: _profileImageUrl.isNotEmpty
//                     ? NetworkImage(_profileImageUrl)
//                     : null,
//                 child: _profileImageUrl.isEmpty
//                     ? Icon(
//                         Icons.add_a_photo,
//                         size: 24.sp,
//                         color: appbarColor,
//                       )
//                     : null,
//               ),
//             ),
//             SizedBox(height: 40.h),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16.w, vertical: 14.h),
//                     ),
//                     validator: (value) =>
//                         value!.isEmpty ? 'Please enter your name' : null,
//                   ),
//                   SizedBox(height: 20.h),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16.w, vertical: 14.h),
//                     ),
//                     validator: (value) => value!.isEmpty || !value.contains('@')
//                         ? 'Please enter a valid email'
//                         : null,
//                   ),
//                   SizedBox(height: 40.h),
//                   ElevatedButton(
//                     onPressed: () {},
//                     // _updateProfile,
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: appbarColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       child: Text(
//                         'Update Profile',
//                         style: TextStyle(
//                             fontSize: 16.sp, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart' as Path;

// class Picker with ChangeNotifier {
//   List<File> _images = [];
//   final picker = ImagePicker();
//   String? _userId;
//   firebase_storage.Reference? ref;

//   List<File> get images {
//     return [..._images];
//   }

//   void updates(String? userId) {
//     _userId = userId;
//     notifyListeners();
//   }

//   Future<void> _retriveLosData() async {
//     final LostDataResponse response = await picker.retrieveLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       _images.add(File(response.file!.path));
//       notifyListeners();
//     } else {
//       log(response.file.toString());
//     }
//   }

//   chooseImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     _images.add(File(pickedFile!.path));

//     if (pickedFile.path == null) {
//       _retriveLosData();
//     }
//     notifyListeners();
//   }

//   Future uploadFile() async {
//     for (var img in _images) {
//       ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('images/$_userId/${Path.basename(img.path)}');
//     }
//   }
// }

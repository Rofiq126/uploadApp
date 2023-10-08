import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:upload_background_app/view/component/notification_service.dart';

class ViewModel extends ChangeNotifier {
  File? selectedImage;
  String message = '';
  int progressUpload = 0;
  UploadTask? uploadTask;
  ServiceNotification serviceNotification = ServiceNotification();

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future uploadImage() async {
    try {
      final path = selectedImage!.path.split('/').last;
      final file = File(selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child(path);

      final uploadTask = ref.putFile(
        file,
      );
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            if (progress != 100.0) {
              progressUpload = progress.roundToDouble().toInt();
              serviceNotification.progressNotification(
                  condition: 'Melakukan upload', progress: progressUpload);
            }
            if (progress == 100.0) {
              serviceNotification.progressNotification(
                  condition: 'Upload selesai', progress: 100);
            }
            debugPrint(
                "Upload is ${progress.roundToDouble().toInt()}% complete.");
            break;
          case TaskState.paused:
            message = "Upload is paused.";
            break;
          case TaskState.canceled:
            message = "Upload was canceled";
            serviceNotification.alertNotification();
            break;
          case TaskState.error:
            message = 'Upload failed';
            break;
          case TaskState.success:
            if (message != 'Upload canceled') {
              message = 'Upload success';
            }
            break;
        }
      });
    } on FirebaseException catch (e) {
      debugPrint(e.code);
    }
    notifyListeners();
  }

  Future cancelUpload() async {
    try {
      final path = selectedImage!.path.split('/').last;
      final file = File(selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child(path).putFile(file);
      await ref.cancel();
      message = 'cancel succes';
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.code}');
    }
    notifyListeners();
  }

  Future anonymousLogin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      message = 'Login succesfull';
      debugPrint("Signed in with temporary account.");
      debugPrint(userCredential.toString());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          message = "Anonymous auth hasn't been enabled for this project.";
          break;
        default:
          message = "Unknown error.";
      }
    }
  }
}

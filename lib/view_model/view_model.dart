import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_background_app/common/custom_alert_dialog.dart';
import 'package:upload_background_app/common/loading_page.dart';
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

  Future uploadImage({required BuildContext context}) async {
    try {
      if (selectedImage != null) {
        final path = selectedImage!.path.split('/').last;
        final file = File(selectedImage!.path);
        final ref = FirebaseStorage.instance.ref().child(path);

        uploadTask = ref.putFile(
          file,
        );
        uploadTask?.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              if (progress != 100.0) {
                progressUpload = progress.roundToDouble().toInt();
                serviceNotification.progressNotification(
                    condition: 'Melakukan upload', progress: progressUpload);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            LoadingScreen(progress: progressUpload)));
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
              message = 'Upload canceled';
              break;
            case TaskState.error:
              message = 'Upload failed';
              break;
            case TaskState.success:
              message = 'Upload success';
              customAlertDialog(
                  context: context,
                  message: 'Upload Success',
                  icon: Icons.check,
                  color: Colors.green);

              break;
          }
        });
      } else {
        message = 'Please select image';
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'firebase_storage/canceled':
          message = 'Cancel success';
          debugPrint(e.code);
          break;
        case 'storage/canceled':
          message = 'Cancel success';
          debugPrint(e.code);
          break;
        default:
          debugPrint('FirebaseException: ${e.code}');
      }
    }
    notifyListeners();
  }

  Future cancelUpload() async {
    try {
      await uploadTask!.pause();
      message = 'cancel succes';
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'firebase_storage/canceled':
          message = 'Cancel success';
          debugPrint(e.code);
          break;
        case 'storage/canceled':
          message = 'Cancel success';
          debugPrint(e.code);
          break;
        case 'firebase_storage/unknown':
          message =
              'Cancel operation was called on a task which does not exist.';
          debugPrint(e.code);
          break;
        case 'Code: -13040 HttpResult: 0':
          message = 'ERORRRRRR';
          debugPrint(e.code);
          break;
        default:
          debugPrint('FirebaseException: ${e.code}');
      }
    }
    notifyListeners();
  }

  Future anonymousLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      message = 'Login succesfull';
      debugPrint("Signed in with temporary account.");
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

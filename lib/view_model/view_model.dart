import 'dart:developer';
import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum StateUpload { running, pause, success, error, cancelled }

class ViewModel extends ChangeNotifier {
  File? selectedImage;
  String message = '';
  double progressUpload = 0.0;
  UploadTask? uploadTask;
  StateUpload stateUpload = StateUpload.running;

  void changeState(StateUpload s) {
    stateUpload = s;
    notifyListeners();
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    notifyListeners();
  }

  Future uploadImage() async {
    try {
      final path = 'files/${selectedImage!.path.split('/').last}';
      final file = File(selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child(path);

      uploadTask = ref.putFile(file);

      uploadTask!.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            changeState(StateUpload.running);
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            changeState(StateUpload.pause);
            message = "Upload is paused.";
            break;
          case TaskState.canceled:
            changeState(StateUpload.cancelled);
            message = "Upload was canceled";
            break;
          case TaskState.error:
            changeState(StateUpload.error);
            message = 'Upload failed';
            break;
          case TaskState.success:
            changeState(StateUpload.success);
            message = 'Upload success';
            break;
        }
      });
      uploadTask = null;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future cancelUpload() async {
    try {
      FirebaseAppCheck.instance.onTokenChange.listen((token) {
        log("App Check token refreshed: $token");
      });
      final path = selectedImage!.path.split('/').last;
      final file = File(selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child(path).putFile(file);
      bool canceled = await ref.cancel();
      if (canceled) {
        log('Upload cancellation successful');

        changeState(StateUpload.cancelled);
      } else {
        log('Upload cancellation failed');
      }

      message = 'Berhasil membatalkan';
    } on FirebaseException catch (e) {
      log('FirebaseException: ${e.toString()}');
    }
    notifyListeners();
  }
}

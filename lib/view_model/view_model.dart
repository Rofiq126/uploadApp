import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewModel extends ChangeNotifier {
  File? selectedImage;
  String message = '';
  double progressUpload = 0.0;
  UploadTask? uploadTask;

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
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            message = "Upload is paused.";
            break;
          case TaskState.canceled:
            message = "Upload was canceled";
            break;
          case TaskState.error:
            message = 'Upload failed';
            break;
          case TaskState.success:
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
      final path = selectedImage!.path.split('/').last;
      final file = File(selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child(path).putFile(file);
      bool canceled = await ref.cancel();
      if (canceled) {
        print('Upload cancellation successful');
      } else {
        print('Upload cancellation failed');
      }

      message = 'Berhasil membatalkan';
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.toString()}');
    }
    notifyListeners();
  }
}

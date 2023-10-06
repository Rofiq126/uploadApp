import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_background_app/view/component/loading_screen.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String message = '';
  UploadTask? uploadTask;
  TaskState? _taskSnapshot;
  double loadingProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Upload App',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.amberAccent),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () {
                  viewModel.pickImage().then((value) => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MainPage())));
                },
                child: const Text(
                  'Pilih Gambar',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 16,
            ),
            viewModel.selectedImage != null
                ? Image.file(
                    viewModel.selectedImage!,
                    width: size.width * 0.7,
                  )
                : const Column(
                    children: [
                      Icon(
                        Icons.hide_image,
                        color: Colors.grey,
                        size: 70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Tolong pilih gambar')
                    ],
                  ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () {
                  try {
                    final path = viewModel.selectedImage!.path.split('/').last;

                    final file = File(viewModel.selectedImage!.path);
                    final ref = FirebaseStorage.instance.ref().child(path);

                    setState(() {
                      uploadTask = ref.putFile(file);
                    });
                    uploadTask!.snapshotEvents
                        .listen((TaskSnapshot taskSnapshot) {
                      _taskSnapshot = taskSnapshot.state;
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          final progress = 100.0 *
                              (taskSnapshot.bytesTransferred /
                                  taskSnapshot.totalBytes);

                          debugPrint("Upload is $progress% complete.");
                          progress != 100.0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoadingScreen(
                                            progress: progress,
                                            viewModel: viewModel,
                                            percent:
                                                '${(progress.roundToDouble())}%',
                                          )))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MainPage()));

                          break;
                        case TaskState.paused:
                          message = "Upload is paused.";
                          break;
                        case TaskState.canceled:
                          message = "Upload was canceled";
                          showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                      content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        size: 70,
                                        color: Colors.amberAccent,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Upload Canceled',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MainPage()));
                          break;
                        case TaskState.error:
                          message = 'Upload failed';
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.cancel,
                                        size: 70,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Upload Failed',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amberAccent),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'))
                                    ],
                                  ),
                                );
                              });
                          break;
                        case TaskState.success:
                          message = 'Upload success';
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        size: 70,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Upload Succesfull',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.amberAccent),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'))
                                    ],
                                  ),
                                );
                              });
                          break;
                      }
                    });

                    uploadTask!.whenComplete(() {});
                    setState(() {
                      uploadTask = null;
                    });
                  } on FirebaseException catch (e) {
                    e.code == 'The operation was cancelled';
                  }
                },
                child: const Text(
                  'Upload Gambar',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
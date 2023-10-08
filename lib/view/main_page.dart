import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_background_app/common/custom_alertDialog.dart';
import 'package:upload_background_app/view/component/notification_service.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String message = '';
  UploadTask? uploadTask;
  int loadingProgress = 0;
  ServiceNotification notificationService = ServiceNotification();

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
                  viewModel.selectedImage = null;
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
            Visibility(
              visible: viewModel.selectedImage == null ? false : true,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent),
                  onPressed: () {
                    viewModel.message = '';
                    viewModel.uploadImage();
                    if (viewModel.message == 'Upload success') {
                      customAlertDialog(
                          context: context,
                          message: 'Upload Success',
                          icon: Icons.check,
                          color: Colors.green);
                    }
                  },
                  child: const Text(
                    'Upload Gambar',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: viewModel.selectedImage == null ? false : true,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent),
                  onPressed: () {
                    viewModel.cancelUpload().then((value) => showDialog(
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
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ))));
                    debugPrint('CANCELLLLLL');
                    setState(() {
                      viewModel.selectedImage = null;
                    });
                  },
                  child: const Text(
                    'Cancel Upload',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

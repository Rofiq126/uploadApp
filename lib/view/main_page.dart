import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent),
                  onPressed: () {
                    viewModel.selectedImage = null;
                    viewModel.pickImage().then((value) => Navigator.push(
                        context,
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
                visible: true,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent),
                    onPressed: () {
                      viewModel.message = '';
                      viewModel.uploadImage(context: context);
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
                visible: false,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent),
                    onPressed: () {},
                    child: const Text(
                      'Cancel Upload',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_background_app/common/custom_alert_dialog.dart';
import 'package:upload_background_app/view/component/notification_service.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class LoadingScreen extends StatefulWidget {
  final int progress;
  const LoadingScreen({Key? key, required this.progress}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ServiceNotification serviceNotification = ServiceNotification();
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ViewModel>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Loading',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.amberAccent),
            ),
            const SizedBox(
              height: 16,
            ),
            const CircularProgressIndicator(
              color: Colors.amberAccent,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '${widget.progress.toString()}%',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amberAccent),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () {
                  viewModel.cancelUpload().then((value) {
                    customAlertDialog(
                        context: context,
                        message: 'Upload Canceled',
                        icon: Icons.check,
                        color: Colors.amber);
                  }).then((value) => serviceNotification.alertNotification());
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

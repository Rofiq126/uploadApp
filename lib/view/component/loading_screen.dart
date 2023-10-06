import 'package:flutter/material.dart';
import 'package:upload_background_app/view/main_page.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class LoadingScreen extends StatefulWidget {
  final double progress;
  String percent;
  ViewModel viewModel;
  LoadingScreen(
      {Key? key,
      required this.progress,
      required this.percent,
      required this.viewModel})
      : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Loading',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.amberAccent),
            ),
            const SizedBox(
              height: 100,
            ),
            const CircularProgressIndicator(
              color: Colors.amberAccent,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.percent,
              style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 27,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () {
                  widget.viewModel.cancelUpload().then((value) =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const MainPage())));
                  debugPrint('CANCELLLLLL');
                },
                child: const Text('Cancel'))
          ],
        ),
      ),
    );
  }
}

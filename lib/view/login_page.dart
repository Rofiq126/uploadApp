import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ViewModel>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              color: Colors.amberAccent,
              size: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Upload App',
              style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () {
                  viewModel
                      .anonymousLogin()
                      .then((value) => viewModel.notifPermission());
                },
                child: const Text(
                  'Masuk Aplikasi',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

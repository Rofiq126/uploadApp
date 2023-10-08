import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_background_app/view/main_page.dart';
import 'package:upload_background_app/view_model/view_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  viewModel.anonymousLogin();
                  if (viewModel.message == 'Login succesfull') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MainPage()));
                  }
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

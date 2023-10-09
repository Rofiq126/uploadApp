import 'package:flutter/material.dart';
import 'package:upload_background_app/view/main_page.dart';

customAlertDialog(
    {required BuildContext context,
    required String message,
    required IconData icon,
    required Color color}) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 70,
                color: color,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                message,
                style: TextStyle(
                    fontSize: 18, color: color, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MainPage()));
                  },
                  child: const Text('Close'))
            ],
          ),
        );
      });
}

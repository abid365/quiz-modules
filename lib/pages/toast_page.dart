import 'package:flutter/material.dart';
import 'package:quiz/components/loader/universal_loader.dart';
import 'package:quiz/components/toast/universal_toast.dart';

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const UniversalToast(
                            state: 'error',
                            errorTitle: 'Successfully created organization',
                            errMessage:
                                'Organization creation successful. You can now post videos and tests. Ask the admin to login and add employees and supervisors.',
                          ));
                },
                child: const Text("Org Created"),
              ),
            ),
            const UniversalLoader()
          ],
        ),
      ),
    );
  }
}

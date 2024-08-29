import 'package:flutter/material.dart';

class UniversalLoader extends StatelessWidget {
  const UniversalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            backgroundColor: Color(0xFF7F56D9),
            // value: 0.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        )
      ],
    ));
  }
}

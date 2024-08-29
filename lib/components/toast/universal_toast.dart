import 'package:flutter/material.dart';

class UniversalToast extends StatefulWidget {
  final String? state;
  final String errorTitle;
  final String errMessage;
  const UniversalToast(
      {this.state,
      required this.errorTitle,
      required this.errMessage,
      super.key});

  @override
  State<UniversalToast> createState() => _UniversalToastState();
}

class _UniversalToastState extends State<UniversalToast> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 227, 219, 219),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color.fromARGB(162, 51, 48, 48), width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.state == 'error'
                      ? Icon(
                          Icons.error_outline_sharp,
                          color: Colors.amber[600],
                          size: 30.0,
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 30.0,
                        ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromARGB(158, 158, 158, 158),
                        size: 30,
                      ))
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.errorTitle,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        widget.errMessage,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

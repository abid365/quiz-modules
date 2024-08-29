import 'package:flutter/material.dart';

class CustomFormFieldWithLabel extends StatelessWidget {
  final FocusNode focusNode;
  final String? hintText;
  final String labelText;
  final String? initalValue;
  final String? Function(String?) validator;
  final Function(String?) onSaved;
  final Function(String?) onChanged;
  const CustomFormFieldWithLabel(
      {required this.focusNode,
      required this.validator,
      required this.onSaved,
      required this.onChanged,
      this.hintText,
      required this.labelText,
      this.initalValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: Row(
            children: [
              Text(
                labelText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            focusNode: focusNode,
            initialValue: initalValue,
            maxLines: 1,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              errorStyle: const TextStyle(color: Colors.indigo),
            ),
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

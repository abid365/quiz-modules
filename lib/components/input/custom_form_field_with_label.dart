import 'package:flutter/material.dart';

class CustomFormFieldWithLabel extends StatefulWidget {
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
  State<CustomFormFieldWithLabel> createState() =>
      _CustomFormFieldWithLabelState();
}

class _CustomFormFieldWithLabelState extends State<CustomFormFieldWithLabel> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initalValue);
  }

  @override
  void didUpdateWidget(CustomFormFieldWithLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initalValue != oldWidget.initalValue) {
      _controller.text = widget.initalValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                widget.labelText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            focusNode: widget.focusNode,
            controller: _controller,
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
            validator: widget.validator,
            onSaved: widget.onSaved,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

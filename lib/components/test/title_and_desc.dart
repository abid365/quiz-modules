import 'package:flutter/material.dart';

class TitleAndDesc extends StatefulWidget {
  Map<String, String> titleAndDesc;

  TitleAndDesc({required this.titleAndDesc, super.key});

  @override
  State<TitleAndDesc> createState() => _TitleAndDescState();
}

class _TitleAndDescState extends State<TitleAndDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              "Test Title*",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 158, 158, 158), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                  ),
                  errorStyle: const TextStyle(color: Colors.indigo),
                  hintText: "Enter test title..."),
              initialValue: widget.titleAndDesc['title'] == null
                  ? ''
                  : widget.titleAndDesc['title']!,
              // validator: handleTitleAndDescription(),
              // controller: widget.titlleController,
              onChanged: (value) {
                setState(() {
                  widget.titleAndDesc['title'] = value;
                });
                debugPrint(value);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Divider(
              thickness: 1.0,
              color: Color.fromARGB(48, 158, 158, 158),
              height: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Test description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
          const SizedBox(height: 5),
          const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              "Write a short description.",
              style: TextStyle(fontSize: 14),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 150,
            child: TextFormField(
              maxLines: 10,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  hintText: "Enter test description..."),
              initialValue: widget.titleAndDesc['description'] == null
                  ? ''
                  : widget.titleAndDesc['description']!,
              // validator: handleTitleAndDescription(),
              // controller: widget.descriptionController,
              onChanged: (value) {
                setState(() {
                  widget.titleAndDesc['description'] = value;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Divider(
              thickness: 1.0,
              color: Color.fromARGB(48, 158, 158, 158),
              height: 10,
            ),
          )
        ],
      ),
    );
  }
}

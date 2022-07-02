import 'package:flutter/material.dart';

class CustomButtonForm extends StatefulWidget {
  final Stream<dynamic>? bloc;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomButtonForm(
      {Key? key,
      required this.bloc,
      required this.text,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  State<CustomButtonForm> createState() => _CustomButtonFormState();
}

class _CustomButtonFormState extends State<CustomButtonForm> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc,
      builder: (context, snapshot) {
        return SizedBox(
          height: 45,
          child: ElevatedButton(
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 15),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(widget.color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: widget.text == "Guardar" || widget.text == "Solicitar"
                  ? snapshot.hasData
                      ? widget.onPressed
                      : null
                  : widget.onPressed),
        );
      },
    );
  }
}

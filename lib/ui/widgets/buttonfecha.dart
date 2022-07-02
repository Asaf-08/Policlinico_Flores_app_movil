import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policlinico_flores/ui/widgets/components.dart';

class ButtonFecha extends StatefulWidget {
  final String title;
  final String? fecha;
  final FormFieldSetter<String> onSaved;

  const ButtonFecha(
      {Key? key,
      required this.title,
      required this.fecha,
      required this.onSaved})
      : super(key: key);

  @override
  State<ButtonFecha> createState() => _ButtonFechaState();
}

class _ButtonFechaState extends State<ButtonFecha> {
  final PickDateState _pickDate = PickDateState();

  @override
  Widget build(BuildContext context) {
    String? dateString = widget.fecha;
    DateTime dateFormat = DateTime.now();

    if (dateString == null) {
      dateFormat;
    } else {
      dateFormat = DateFormat("dd/MM/y").parse(dateString);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title),
        FormField<String>(
          initialValue: _fecha(dateFormat),
          onSaved: widget.onSaved,
          builder: (FormFieldState state) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      state.value,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size.fromHeight(40)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 187, 64)),
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
                    onPressed: () async {
                      final date = await _pickDate.pickDate(context);
                      if (date == null) return;
                      setState(() {
                        dateFormat = date;
                        String fecha = _fecha(dateFormat);
                        state.didChange(fecha);
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  _fecha(DateTime dateFormat) {
    String date = "${dateFormat.day}/${dateFormat.month}/${dateFormat.year}";
    return date;
  }
}

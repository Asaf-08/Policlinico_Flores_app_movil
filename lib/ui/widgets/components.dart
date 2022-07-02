import 'package:flutter/material.dart';
import 'package:policlinico_flores/ui/widgets/customclipper.dart';

//Fondo -----------------------------------------------------------
class FondoForms extends StatelessWidget {
  final String title, subtitle;
  final String nameUI;
  final Color colorfondo;
  final Color colorclip1;
  final Color colorclip2;

  const FondoForms(
      {Key? key,
      required this.nameUI,
      required this.colorfondo,
      required this.colorclip1,
      required this.colorclip2,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: title == "Policlínico Flores" ? 55 : 25,
                horizontal: 35),
            title: Text(title,
                style: TextStyle(
                    color: nameUI == "Login" || nameUI == "Register"
                        ? const Color.fromARGB(255, 0, 23, 60)
                        : Colors.white,
                    fontSize:
                        nameUI == "Login" || nameUI == "Register" ? 30 : 25,
                    fontWeight: FontWeight.w400)),
            subtitle: Text(subtitle,
                style: TextStyle(
                    color: nameUI == "Login" || nameUI == "Register"
                        ? const Color.fromARGB(255, 0, 23, 60)
                        : Colors.white)),
          ),
          height: nameUI == "Login" || nameUI == "Register"
              ? size.height
              : size.height * .35,
          decoration: BoxDecoration(
            color: colorfondo,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
        ClipperCustom(
            context: context,
            nameUI: nameUI,
            color1: colorclip1,
            color2: colorclip2),
      ],
    );
  }
}

//Fecha y hora -----------------------------------------------------------
class PickDate extends StatefulWidget {
  const PickDate({Key? key}) : super(key: key);

  @override
  State<PickDate> createState() => PickDateState();
}

class PickDateState extends State<PickDate> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
        context: context,
        locale: const Locale("es", "PE"),
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2900),
      );
}

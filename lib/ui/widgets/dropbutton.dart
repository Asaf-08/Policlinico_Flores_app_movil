import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String title;
  dynamic selectedvalue;
  final List<DropdownMenuItem<dynamic>> lista;
  final dynamic value;
  final FormFieldSetter<String> onSaved;
  String? Function(String?)? validator;

  CustomDropdownButton(
      {Key? key,
      required this.title,
      this.selectedvalue,
      required this.lista,
      required this.value,
      required this.onSaved,
      this.validator})
      : super(key: key);

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.title),
        const SizedBox(height: 3),
        FormField<String?>(
          initialValue: widget.value == null
              ? widget.selectedvalue.toString()
              : widget.value.toString(),
          onSaved: widget.onSaved,
          validator: widget.validator,
          builder: (FormFieldState<String?> state) {
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 237, 237),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: state.hasError
                          ? Border.all(color: Colors.redAccent.shade700)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField<dynamic>(
                        isExpanded: true,
                        value: widget.value ?? widget.selectedvalue,
                        elevation: 16,
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none),
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue.toString());
                          setState(() {
                            widget.selectedvalue =
                                newValue ?? widget.selectedvalue;
                          });
                        },
                        items: widget.lista,
                      ),
                    ),
                  ),
                ),
                _validate(state),
              ],
            );
          },
        ),
      ],
    );
  }

  _validate(FormFieldState<String?> state) {
    if (state.hasError) {
      return Column(
        children: [
          const SizedBox(height: 5.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                state.hasError ? state.errorText.toString() : '',
                style:
                    TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

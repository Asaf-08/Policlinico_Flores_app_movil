import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomInputForm extends StatefulWidget {
  final Stream<dynamic>? bloc;
  String? value;
  final String lblText;
  String? msgError;
  final FormFieldSetter<String>? onSaved;
  final Function(String)? change;

  CustomInputForm({
    Key? key,
    required this.bloc,
    required this.value,
    required this.lblText,
    this.msgError,
    required this.onSaved,
    required this.change,
  }) : super(key: key);

  @override
  State<CustomInputForm> createState() => _CustomInputFormState();
}

class _CustomInputFormState extends State<CustomInputForm> {
  final FocusNode _focusNode = FocusNode();
  TextStyle labelStyle = const TextStyle(color: Colors.black38);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_requestFocus);
  }

  void _requestFocus() {
    setState(() {
      labelStyle =
          TextStyle(color: _focusNode.hasFocus ? Colors.blue : Colors.black26);
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_requestFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc,
      builder: (context, snapshot) {
        return SizedBox(
          child: TextFormField(
            obscureText: widget.lblText == "Contraseña" ||
                    widget.lblText == "Confirmar contraseña"
                ? true
                : false,
            maxLines: widget.lblText == "Motivo de consulta" ? 6 : 1,
            initialValue: widget.value == "null" ? null : widget.value,
            focusNode: _focusNode,
            onTap: _requestFocus,
            keyboardType: _typeInput(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              labelText: widget.lblText,
              labelStyle: labelStyle,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: .8,
                  color: Colors.black26,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              errorText: snapshot.error?.toString(),
            ),
            onSaved: widget.onSaved,
            validator: widget.lblText != "Edad"
                ? (value) {
                    if (value!.isEmpty) {
                      return widget.msgError;
                    } else {
                      return null;
                    }
                  }
                : null,
            onChanged: widget.change,
          ),
        );
      },
    );
  }

  _typeInput() {
    if (widget.lblText == "Edad" || widget.lblText == "DNI") {
      return TextInputType.number;
    } else if (widget.lblText == "Teléfono") {
      return TextInputType.phone;
    } else {
      return TextInputType.text;
    }
  }
}

//Input para Login y Registro -----------------------------------------------------------
class InputAlternative extends StatefulWidget {
  BehaviorSubject<String>? getStream;
  final Stream<dynamic>? bloc;
  String? value;
  String? msgError;
  final String nameForm;
  final String label;
  final String inputHint;
  final FormFieldSetter<String>? onSaved;
  final Function(String)? change;
  InputAlternative(
      {Key? key,
      required this.getStream,
      required this.bloc,
      required this.value,
      this.msgError,
      required this.nameForm,
      required this.label,
      required this.inputHint,
      required this.onSaved,
      required this.change})
      : super(key: key);

  @override
  State<InputAlternative> createState() => _InputAlternativeState();
}

class _InputAlternativeState extends State<InputAlternative> {
  final TextEditingController _heightController = TextEditingController();
  bool isSubmitted = false;
  final Icon checkBoxIcon =
      const Icon(Icons.verified_outlined, color: Colors.black);
  final FocusNode _focusNode = FocusNode();
  bool labelStyle = false;
  bool _showClearButton = false;
  bool obsecureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_requestFocus);
    _heightController.addListener(() {
      setState(() {
        _showClearButton = _heightController.text.isNotEmpty;
      });
    });
  }

  void _requestFocus() {
    setState(() {
      labelStyle = _focusNode.hasFocus ? true : false;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_requestFocus);
    _heightController.dispose();
    super.dispose();
  }

  void _showPassword() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () {
        _heightController.clear();
        widget.getStream?.value = "";
      },
      icon: const Icon(Icons.clear),
    );
  }

  Widget _getShowButton() {
    if (!obsecureText) {
      return IconButton(
        onPressed: () => _showPassword(),
        icon: const Icon(Icons.visibility_off),
      );
    }

    return IconButton(
      onPressed: () => _showPassword(),
      icon: const Icon(Icons.visibility),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.bloc,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Focus(
                  child: TextFormField(
                    obscureText: widget.label == "Contraseña" ||
                            widget.label == "Confirmar contraseña"
                        ? obsecureText
                        : false,
                    controller: _heightController,
                    focusNode: _focusNode,
                    onTap: _requestFocus,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: const Color(0xFF0962FF),
                      fontSize: widget.nameForm == "Login" ? 16 : 14,
                    ),
                    decoration: InputDecoration(
                      labelText:
                          widget.nameForm != "Login" ? widget.label : null,
                      labelStyle: TextStyle(
                          color:
                              widget.nameForm != "Login" && labelStyle == true
                                  ? const Color.fromARGB(255, 0, 108, 223)
                                  : Colors.grey),
                      hintText:
                          widget.nameForm == "Login" ? widget.inputHint : null,
                      hintStyle: widget.nameForm == "Login"
                          ? const TextStyle(color: Colors.grey)
                          : null,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: widget.nameForm == "Login" ? 15 : 13,
                          horizontal: 25),
                      focusColor: const Color(0xFF0962FF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _heightController.value.text.isEmpty
                              ? Colors.grey
                              : const Color(0xFF0962FF),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0962FF),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      suffixIcon: widget.label == "Contraseña" ||
                              widget.label == "Confirmar contraseña"
                          ? _getShowButton()
                          : _getClearButton(),
                      prefixIcon: widget.label == "Buscar"
                          ? const Icon(Icons.search)
                          : null,
                      errorText: snapshot.error?.toString(),
                    ),
                    onSaved: widget.onSaved,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return widget.msgError;
                      } else {
                        return null;
                      }
                    },
                    onChanged: widget.change,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

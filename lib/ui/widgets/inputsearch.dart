import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  final String? txtLabel;
  final Function(String)? change;
  final Function(String)? search;
  const InputSearch({
    Key? key,
    required this.txtLabel,
    required this.change,
    required this.search,
  }) : super(key: key);

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
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

  Widget _getClearButton() {
    if (!_showClearButton) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () {
        _heightController.clear();
        widget.search!("");
      },
      icon: const Icon(Icons.clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Focus(
            child: TextFormField(
              controller: _heightController,
              focusNode: _focusNode,
              onTap: _requestFocus,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Color(0xFF0962FF),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: widget.txtLabel,
                labelStyle: TextStyle(
                    color: labelStyle == true
                        ? const Color.fromARGB(255, 0, 108, 223)
                        : Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
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
                suffixIcon: _getClearButton(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: widget.change,
            ),
          ),
        ),
      ],
    );
  }
}

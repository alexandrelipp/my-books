import 'package:flutter/material.dart';

class TextFormWithIcon extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function validator;
  final Function onSave;
  final Function onChanged;
  final String initialValue;

  TextFormWithIcon(
    this.iconData,
    this.text, {
    this.initialValue,
    this.onChanged,
    this.validator,
    this.onSave,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onSaved: onSave,
        textInputAction: TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          labelText: text,
          icon: Icon(iconData),
        ),
      ),
    );
  }
}

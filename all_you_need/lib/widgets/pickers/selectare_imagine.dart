import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectareImagine extends StatefulWidget {
  final Function(File pozaSel) fctSelPoza;
  final String? _pozaDefault;
  final String _text;

  const SelectareImagine(this.fctSelPoza, this._pozaDefault, this._text,
      {super.key});

  @override
  State<SelectareImagine> createState() => _SelectareImagineState();
}

class _SelectareImagineState extends State<SelectareImagine> {
  File? _pozaSelectata;
  bool selectat = false;

  void _selecteazaImag() async {
    final selector = ImagePicker();
    final imagSelectata = await selector.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    );
    final fisierImagineSel = File(imagSelectata!.path);
    setState(() {
      _pozaSelectata = fisierImagineSel;
      selectat = true;
    });
    widget.fctSelPoza(fisierImagineSel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: selectat == false
              ? (widget._pozaDefault == null
                  ? null
                  : NetworkImage(widget._pozaDefault!.toString()))
              : FileImage(_pozaSelectata!) as ImageProvider,
        ),
        TextButton.icon(
          onPressed: _selecteazaImag,
          icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
          label: Text(
            widget._text,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}

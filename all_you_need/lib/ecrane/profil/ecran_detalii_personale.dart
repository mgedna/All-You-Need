import 'dart:io';

import 'package:all_you_need/ecrane/profil/ecran_profil.dart';
import 'package:all_you_need/widgets/pickers/selectare_imagine.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class EcranDetaliiPersonale extends StatefulWidget {
  static const routeName = '/detaliiPersonale';
  const EcranDetaliiPersonale({super.key});

  @override
  State<EcranDetaliiPersonale> createState() => _EcranDetaliiPersonaleState();
}

class _EcranDetaliiPersonaleState extends State<EcranDetaliiPersonale> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  var _gen = '';
  var _dataNastere = '';
  late String _poza;
  bool seSalveaza = false;

  File? _pozaUser;

  void _imagineSelectata(File imagine) {
    _pozaUser = imagine;
  }

  void _salveaza() async {
    setState(() {
      seSalveaza = true;
    });
    final navigator = Navigator.of(context);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_pozaUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'username': _username,
          'gen': _gen,
          'dataNasterii': _dataNastere,
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('poze_profil')
            .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
        UploadTask uploadTask = ref.putFile(_pozaUser!);
        await Future.value(uploadTask);
        String url = "";
        await ref.getDownloadURL().then((value) => url = value);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'pozaProfil': url,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'username': _username,
          'gen': _gen,
          'dataNasterii': _dataNastere,
        });
      }
      setState(() {
        seSalveaza = false;
      });
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => EcranProfil(seSalveaza: seSalveaza),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: HexColor('030303'),
      ),
      drawer: const Meniu(),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              if (userData == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _poza = userData['pozaProfil'];
              _username = userData['username'];
              _gen = userData['gen'];
              _dataNastere = userData['dataNasterii'] ?? '';

              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 2),
                    width: double.infinity,
                    child: SelectareImagine(
                        _imagineSelectata, _poza, 'Editeaza fotografia'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 30),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey('username'),
                                  validator: (value) {
                                    if (value != null && (value.isEmpty)) {
                                      return 'Introduceți numele de utilizator';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Nume de utilizator',
                                  ),
                                  initialValue: _username,
                                  onSaved: (value) {
                                    _username = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                DropdownButtonFormField(
                                  key: const ValueKey('gen'),
                                  onChanged: (value) {
                                    setState(() {
                                      _gen = value!;
                                    });
                                  },
                                  onSaved: (newValue) {
                                    setState(() {
                                      _gen = newValue!;
                                    });
                                  },
                                  value: _gen != '-' ? _gen : null,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Feminin',
                                      child: Text('Feminin'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Masculin',
                                      child: Text('Masculin'),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Alegeți genul';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      const InputDecoration(labelText: 'Gen'),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                InputDatePickerFormField(
                                  key: const ValueKey('dataNasterii'),
                                  fieldLabelText: 'Data nasterii',
                                  fieldHintText: 'Luna/Zi/An',
                                  errorFormatText: 'Introduceti o data valida',
                                  errorInvalidText:
                                      'Introduceti o data in intervalul valid',
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2023),
                                  keyboardType: TextInputType.text,
                                  initialDate: _dataNastere != ''
                                      ? DateFormat('dd/MM/yyyy')
                                          .parse(_dataNastere)
                                      : null,
                                  onDateSaved: (value) {
                                    _dataNastere =
                                        DateFormat('dd/MM/yyyy').format(value);
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () => _salveaza(),
                                  child: const Text('Salvează'),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  const BaraNavigare(),
                ],
              );
            }),
      ),
    );
  }
}

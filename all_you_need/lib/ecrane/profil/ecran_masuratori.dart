import 'package:all_you_need/ecrane/profil/ecran_profil.dart';
import 'package:all_you_need/helpers/calculator_body_fat.dart';
import 'package:all_you_need/helpers/calculator_necesar_caloric.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EcranMasuratori extends StatefulWidget {
  static const routeName = '/ecranMasuratori';
  const EcranMasuratori({super.key});

  @override
  State<EcranMasuratori> createState() => _EcranMasuratoriState();
}

class _EcranMasuratoriState extends State<EcranMasuratori> {
  final _formKey = GlobalKey<FormState>();
  var _gen = '';
  var _dataNasterii = '';
  var _inaltime = '';
  var _greutate = '';
  var _greutateDorita = '';
  var _talie = '';
  var _gat = '';
  var _sold = '';
  var _nivelActivitate = '';
  int _procent = 0;
  int _necesarCaloric = 0;

  void _salveaza() async {
    final navigator = Navigator.of(context);

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_gen == 'Masculin') {
        _sold = '0';
      }
      setState(() {
        _procent = CalculatorBodyFat.calculeazaBodyFat(
            _gen,
            int.parse(_inaltime),
            int.parse(_talie),
            int.parse(_gat),
            int.parse(_sold));
      });
      var varsta = DateTime.now().year -
          DateFormat('dd/MM/yyyy').parse(_dataNasterii).year;
      _necesarCaloric = CalculatorNecesarCaloric.calculeazaNecesarCaloric(
          _gen,
          int.parse(_greutate),
          int.parse(_greutateDorita),
          int.parse(_inaltime),
          varsta,
          _nivelActivitate);
      await FirebaseFirestore.instance
          .collection('users')
          .doc((FirebaseAuth.instance.currentUser!).uid)
          .collection('masuratori')
          .add({
        'data': DateTime.now(),
        'inaltime': _inaltime,
        'greutate': _greutate,
        'greutateObiectiv': _greutateDorita,
        'talie': _talie,
        'gat': _gat,
        'sold': _sold,
        'nivelActivitate': _nivelActivitate,
      });
      var necesarProteine = CalculatorNecesarCaloric.proteine(_necesarCaloric);
      var necesarCarbo = CalculatorNecesarCaloric.carbohidrati(_necesarCaloric);
      var necesarGrasimi = CalculatorNecesarCaloric.grasimi(_necesarCaloric);
      var necesarFibre = CalculatorNecesarCaloric.fibre(_necesarCaloric);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'bodyFat': _procent,
        'necesarCaloric': _necesarCaloric,
        'necesarProteine': necesarProteine,
        'necesarCarbohidrati': necesarCarbo,
        'necesarGrasimi': necesarGrasimi,
        'necesarFibre': necesarFibre,
        'necesarLichide': ((_necesarCaloric / 30) * 29.5735).round(),
      });
    }
    navigator.pushReplacementNamed(EcranProfil.routeName);
  }

  Future<void> _getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _gen = value.data()!['gen'].toString();
        _dataNasterii = value.data()!['dataNasterii'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Masuratori'),
      drawer: const Meniu(),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('masuratori')
              .orderBy('data', descending: true)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var userDoc = snapshot.data!.docs.isNotEmpty
                ? snapshot.data!.docs.last
                : null;
            if (userDoc != null && userDoc.exists) {
              var userData = userDoc.data();

              _inaltime = userData['inaltime'] ?? '';
              _greutate = userData['greutate'] ?? '';
              _greutateDorita = userData['greutateObiectiv'] ?? '';
              _talie = userData['talie'] ?? '';
              _gat = userData['gat'] ?? '';
              _sold = userData['sold'] ?? '';
              _nivelActivitate = userData['nivelActivitate'] ?? '';
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                key: const ValueKey('inaltime'),
                                initialValue:
                                    _inaltime != '' ? _inaltime : null,
                                validator: (value) {
                                  if (value != null && (value.isEmpty)) {
                                    return 'Introduceți înălțimea';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Înălțime (în cm)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSaved: (value) {
                                  _inaltime = value!;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                key: const ValueKey('greutate'),
                                initialValue:
                                    _greutate != '' ? _greutate : null,
                                validator: (value) {
                                  if (value != null && (value.isEmpty)) {
                                    return 'Introduceți greutatea';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Greutate (în kg)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSaved: (value) {
                                  _greutate = value!;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                key: const ValueKey('greutateDorita'),
                                initialValue: _greutateDorita != ''
                                    ? _greutateDorita
                                    : null,
                                validator: (value) {
                                  if (value != null && (value.isEmpty)) {
                                    return 'Introduceți greutatea dorita';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Greutate dorita (în kg)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSaved: (value) {
                                  _greutateDorita = value!;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                key: const ValueKey('talie'),
                                initialValue: _talie != '' ? _talie : null,
                                validator: (value) {
                                  if (value != null && (value.isEmpty)) {
                                    return 'Introduceți circumferința taliei';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Circumferința taliei (în cm)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSaved: (value) {
                                  _talie = value!;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                key: const ValueKey('gat'),
                                initialValue: _gat != '' ? _gat : null,
                                validator: (value) {
                                  if (value != null && (value.isEmpty)) {
                                    return 'Introduceți circumferința gâtului';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Circumferința gâtului (în cm)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSaved: (value) {
                                  _gat = value!;
                                },
                              ),
                              if (_gen == 'Feminin')
                                const SizedBox(
                                  height: 12,
                                ),
                              if (_gen == 'Feminin')
                                TextFormField(
                                  key: const ValueKey('sold'),
                                  initialValue: _sold != '' ? _sold : null,
                                  validator: (value) {
                                    if (value != null && (value.isEmpty)) {
                                      return 'Introduceți circumferința șoldului';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Circumferința șoldului (în cm)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  onSaved: (value) {
                                    _sold = value!;
                                  },
                                ),
                              const SizedBox(
                                height: 12,
                              ),
                              DropdownButtonFormField(
                                key: const ValueKey('nivelActivitate'),
                                onChanged: (value) {
                                  setState(() {
                                    _nivelActivitate = value!;
                                  });
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    _nivelActivitate = newValue!;
                                  });
                                },
                                value: _nivelActivitate != ''
                                    ? _nivelActivitate
                                    : null,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Sedentar',
                                    child: Text(
                                        'Sedentar (putin exercitiu sau deloc)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Activitate usoara',
                                    child: Text(
                                        'Activitate usoara (1-3 zile/saptamana)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Activitate moderata',
                                    child: Text(
                                        'Activitate moderata (3-5 zile/saptamana)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Activ',
                                    child: Text('Activ (6-7 zile/saptamana)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Foarte activ',
                                    child: Text(
                                        'Foarte activ (intens 6-7 zile/saptamana)'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Alegeți nivelul de activitate';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Nivel de activitate'),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                onPressed: () => _salveaza(),
                                child: const Text('Salveaza'),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const BaraNavigare(),
              ],
            );
          },
        ),
      ),
    );
  }
}

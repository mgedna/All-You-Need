import 'package:all_you_need/helpers/calculator_body_fat.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:flutter/material.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:flutter/services.dart';

class EcranBodyFat extends StatefulWidget {
  static const routeName = '/bodyFat';

  const EcranBodyFat({super.key});

  @override
  State<EcranBodyFat> createState() => _EcranBodyFatState();
}

class _EcranBodyFatState extends State<EcranBodyFat> {
  final _formKey = GlobalKey<FormState>();
  var _gen = '';
  var _inaltime = '';
  var _talie = '';
  var _gat = '';
  var _sold = '';
  int _procent = 0;
  var _interpretare = '';
  var _afisareInterpretare = false;

  void _calculeaza() {
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
        _interpretare = CalculatorBodyFat.interpretare(_gen, _procent);
        _afisareInterpretare = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Calculator BF'),
      drawer: const Meniu(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          key: const ValueKey('gen'),
                          onChanged: (value) {
                            setState(() {
                              _gen = value!;
                            });
                          },
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
                          decoration: const InputDecoration(labelText: 'Gen'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          key: const ValueKey('inaltime'),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onSaved: (value) {
                            _inaltime = value!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          key: const ValueKey('talie'),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                        ElevatedButton(
                          onPressed: () => _calculeaza(),
                          child: const Text('Calculează'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_afisareInterpretare)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                height: 80,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Procent de grăsime',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$_procent%',
                          style: const TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Interpretare',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        _interpretare != 'Mai puțin decât grăsimea esențială'
                            ? Text(
                                _interpretare,
                                style: const TextStyle(fontSize: 23),
                              )
                            : Text(
                                _interpretare,
                                style: const TextStyle(fontSize: 12),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            const BaraNavigare(),
          ],
        ),
      ),
    );
  }
}

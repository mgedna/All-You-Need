import 'package:all_you_need/ecrane/profil/ecran_detalii_personale.dart';
import 'package:all_you_need/ecrane/profil/ecran_masuratori.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';

class EcranSanatate extends StatefulWidget {
  static const routeName = '/sanatate';
  const EcranSanatate({super.key});

  @override
  State<EcranSanatate> createState() => _EcranSanatateState();
}

class _EcranSanatateState extends State<EcranSanatate> {
  final _formKey = GlobalKey<FormState>();
  var _gen = '';
  var _dataNasterii = '';
  var _inaltime = '';
  var _greutate = '';
  var _nivelActivitate = '';
  var _tensiuneSistolica = '';
  var _tensiuneDiastolica = '';
  var _colesterol = '';
  var _glucoza = '';
  var _fumator = '';
  var _consAlcool = '';
  var _risc = '';
  var _probabilitate = '';
  var _isLoading = false;
  var _mesajDialog = '';
  Future<void> _getDate() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _gen = value.data()!['gen'].toString() == 'Masculin' ? '2' : '1';
        _dataNasterii = value.data()!['dataNasterii'].toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('masuratori')
        .orderBy('data', descending: true)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          _inaltime = value.docs.last.data()['inaltime'];
          _greutate = value.docs.last.data()['greutate'];
          _nivelActivitate =
              value.docs.last.data()['nivelActivitate'] != 'Sedentar'
                  ? '1'
                  : '0';
        });
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> clasificareDate() async {
    var varsta = DateTime.now()
        .difference(DateFormat('dd/MM/yyyy').parse(_dataNasterii))
        .inDays;
    const apiUrl = 'http://10.0.2.2:5000/classify';
    final data = {
      'features': [
        varsta,
        int.parse(_gen),
        int.parse(_inaltime),
        double.parse(_greutate),
        int.parse(_tensiuneSistolica),
        int.parse(_tensiuneDiastolica),
        int.parse(_colesterol),
        int.parse(_glucoza),
        int.parse(_fumator),
        int.parse(_consAlcool),
        int.parse(_nivelActivitate)
      ]
    };
    try {
      final raspuns = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));

      if (raspuns.statusCode == 200) {
        final rezultat = json.decode(raspuns.body);
        setState(() {
          _risc = rezultat['predictie'].toString();
          _probabilitate = rezultat['probabilitate'].toString();
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc((FirebaseAuth.instance.currentUser!).uid)
            .update({
          'riscCardiovascular': _risc,
        });
      } else {
        setState(() {
          _mesajDialog =
              'Nu am putut face predictia. Eroare: ${raspuns.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _mesajDialog =
            'Nu am putut face predictia. Eroare: ${error.toString()}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  void _salveaza() async {
    final navigator = Navigator.of(context);

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc((FirebaseAuth.instance.currentUser!).uid)
          .collection('prezicereRiscCardiovascular')
          .add({
        'data': DateTime.now(),
        'tensiuneSistolica': _tensiuneSistolica,
        'tensiuneDiastolica': _tensiuneDiastolica,
        'colesterol': _colesterol,
        'glucoza': _glucoza,
        'fumator': _fumator,
        'consumatorAlcool': _consAlcool,
      });

      await clasificareDate();
      setState(() {
        _isLoading = false;
      });
      if (_risc == '0' && double.parse(_probabilitate) < 50) {
        setState(() {
          _mesajDialog = 'Nu aveti risc cardiovascular.';
        });
      } else {
        setState(() {
          _mesajDialog =
              'Aveti o probabilitate de $_probabilitate% de a avea risc cardiovascular. Consultati un doctor!';
        });
      }
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(_mesajDialog),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      navigator.pop();
                      navigator.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Monitorizare Sanatate'),
      drawer: const Meniu(),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _gen == ''
                ? Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              EcranDetaliiPersonale.routeName);
                        },
                        child: const Text('Completati intai datele personale!'),
                      ),
                      const Expanded(child: SizedBox()),
                      const BaraNavigare(),
                    ],
                  )
                : _greutate == ''
                    ? Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  EcranMasuratori.routeName);
                            },
                            child: const Text('Completati intai masuratorile.'),
                          ),
                          const Expanded(child: SizedBox()),
                          const BaraNavigare(),
                        ],
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('prezicereRiscCardiovascular')
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
                            _tensiuneSistolica =
                                userData['tensiuneSistolica'] ?? '';
                            _tensiuneDiastolica =
                                userData['tensiuneDiastolica'] ?? '';
                            _colesterol = userData['colesterol'] ?? '';
                            _glucoza = userData['glucoza'] ?? '';
                            _fumator = userData['fumator'] ?? '';
                            _consAlcool = userData['consumatorAlcool'] ?? '';
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
                                            key: const ValueKey('tenSistolica'),
                                            initialValue:
                                                _tensiuneSistolica != ''
                                                    ? _tensiuneSistolica
                                                    : null,
                                            validator: (value) {
                                              if (value != null &&
                                                  (value.isEmpty)) {
                                                return 'Introduceți valoarea tensiunii arteriale sistolice.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Valoarea tensiunii arteriale sistolice',
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            onSaved: (value) {
                                              _tensiuneSistolica = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          TextFormField(
                                            key:
                                                const ValueKey('tenDiastolica'),
                                            initialValue:
                                                _tensiuneDiastolica != ''
                                                    ? _tensiuneDiastolica
                                                    : null,
                                            validator: (value) {
                                              if (value != null &&
                                                  (value.isEmpty)) {
                                                return 'Introduceți valoarea tensiunii arteriale diastolice.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Valoarea tensiunii arteriale diastolice',
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            onSaved: (value) {
                                              _tensiuneDiastolica = value!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          DropdownButtonFormField(
                                            key: const ValueKey('colesterol'),
                                            onChanged: (value) {
                                              setState(() {
                                                _colesterol = value!;
                                              });
                                            },
                                            onSaved: (newValue) {
                                              setState(() {
                                                _colesterol = newValue!;
                                              });
                                            },
                                            value: _colesterol != ''
                                                ? _colesterol
                                                : null,
                                            items: const [
                                              DropdownMenuItem(
                                                value: '1',
                                                child: Text('Normal'),
                                              ),
                                              DropdownMenuItem(
                                                value: '2',
                                                child: Text('Peste normal'),
                                              ),
                                              DropdownMenuItem(
                                                value: '3',
                                                child:
                                                    Text('Mult peste normal'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Alegeți interpretarea testului de colesterol.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Interpretarea colesterolului'),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          DropdownButtonFormField(
                                            key: const ValueKey('glucoza'),
                                            onChanged: (value) {
                                              setState(() {
                                                _glucoza = value!;
                                              });
                                            },
                                            onSaved: (newValue) {
                                              setState(() {
                                                _glucoza = newValue!;
                                              });
                                            },
                                            value: _glucoza != ''
                                                ? _glucoza
                                                : null,
                                            items: const [
                                              DropdownMenuItem(
                                                value: '1',
                                                child: Text('Normal'),
                                              ),
                                              DropdownMenuItem(
                                                value: '2',
                                                child: Text('Peste normal'),
                                              ),
                                              DropdownMenuItem(
                                                value: '3',
                                                child:
                                                    Text('Mult peste normal'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Alegeți interpretarea testului de glucoză.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Interpretarea glucozei'),
                                          ),
                                          DropdownButtonFormField(
                                            key: const ValueKey('fumator'),
                                            onChanged: (value) {
                                              setState(() {
                                                _fumator = value!;
                                              });
                                            },
                                            onSaved: (newValue) {
                                              setState(() {
                                                _fumator = newValue!;
                                              });
                                            },
                                            value: _fumator != ''
                                                ? _fumator
                                                : null,
                                            items: const [
                                              DropdownMenuItem(
                                                value: '1',
                                                child: Text('Da'),
                                              ),
                                              DropdownMenuItem(
                                                value: '0',
                                                child: Text('Nu'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Alegeți dacă sunteți sau nu fumător.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                labelText: 'Sunteți fumător?'),
                                          ),
                                          DropdownButtonFormField(
                                            key: const ValueKey('alcool'),
                                            onChanged: (value) {
                                              setState(() {
                                                _consAlcool = value!;
                                              });
                                            },
                                            onSaved: (newValue) {
                                              setState(() {
                                                _consAlcool = newValue!;
                                              });
                                            },
                                            value: _consAlcool != ''
                                                ? _consAlcool
                                                : null,
                                            items: const [
                                              DropdownMenuItem(
                                                value: '1',
                                                child: Text('Da'),
                                              ),
                                              DropdownMenuItem(
                                                value: '0',
                                                child: Text('Nu'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Alegeți dacă consumați sau nu alcool.';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                labelText: 'Consumați alcool?'),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          ElevatedButton(
                                            onPressed: () => _salveaza(),
                                            child: const Text('Salvează'),
                                          ),
                                          if (_isLoading)
                                            const CircularProgressIndicator(),
                                        ],
                                      ),
                                    ),
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

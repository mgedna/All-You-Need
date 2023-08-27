import 'package:all_you_need/ecrane/antrenament/ecran_antrenament.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EcranAlegereGreutate extends StatefulWidget {
  final String tip;
  final String exercitiu1;
  final String exercitiu2;
  final String exercitiu3;
  const EcranAlegereGreutate(
      this.tip, this.exercitiu1, this.exercitiu2, this.exercitiu3,
      {super.key});

  @override
  State<EcranAlegereGreutate> createState() => _EcranAlegereGreutateState();
}

class _EcranAlegereGreutateState extends State<EcranAlegereGreutate> {
  final _formKey = GlobalKey<FormState>();
  var _greutate1 = '';
  var _greutate2 = '';
  var _greutate3 = '';
  void _salveaza() async {
    var navigator = Navigator.of(context);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _greutate1 = double.parse(_greutate1).toString();
        _greutate2 = double.parse(_greutate2).toString();
        _greutate3 = double.parse(_greutate3).toString();
      });
      if (widget.tip == 'Antrenament A') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'greutateA1': _greutate1,
          'greutateA2': _greutate2,
          'greutateA3': _greutate3,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'greutateB1': _greutate1,
          'greutateB2': _greutate2,
          'greutateB3': _greutate3,
        });
      }
    }
    navigator.pushReplacementNamed(EcranAntrenament.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers(''),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      'Alegere greutate pentru ${widget.tip}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              key: const ValueKey('gr1'),
                              validator: (value) {
                                if (value != null && (value.isEmpty)) {
                                  return 'Introduceți greutatea pentru ${widget.exercitiu1}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText:
                                    'Greutate pentru ${widget.exercitiu1}',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onSaved: (value) {
                                _greutate1 = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              key: const ValueKey('gr2'),
                              validator: (value) {
                                if (value != null && (value.isEmpty)) {
                                  return 'Introduceți greutatea pentru ${widget.exercitiu2}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText:
                                    'Greutate pentru ${widget.exercitiu2}',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onSaved: (value) {
                                _greutate2 = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              key: const ValueKey('gr3'),
                              validator: (value) {
                                if (value != null && (value.isEmpty)) {
                                  return 'Introduceți greutatea pentru ${widget.exercitiu3}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText:
                                    'Greutate pentru ${widget.exercitiu3}',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onSaved: (value) {
                                _greutate3 = value!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: () => _salveaza(),
                              child: const Text('Salvează'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Row(
                      children: const [
                        Icon(Icons.help_outline),
                        Expanded(
                          child: Text(
                              'Alegeți-vă greutatea pentru a reuși să faceți 10 repetări din exercițiu.'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

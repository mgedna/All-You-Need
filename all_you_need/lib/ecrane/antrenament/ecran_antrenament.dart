import 'package:all_you_need/ecrane/antrenament/ecran_alegere_greutate.dart';
import 'package:all_you_need/ecrane/antrenament/ecran_alegere_zile.dart';
import 'package:all_you_need/ecrane/antrenament/ecran_exercitiu.dart';
import 'package:all_you_need/ecrane/antrenament/ecran_feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class EcranAntrenament extends StatefulWidget {
  static const routeName = '/antrenamente';
  final List<dynamic>? exercitii;
  const EcranAntrenament({super.key, this.exercitii});

  @override
  State<EcranAntrenament> createState() => _EcranAntrenamentState();
}

class _EcranAntrenamentState extends State<EcranAntrenament> {
  var _ziAntr = false;
  var _zileActive = [];
  var _pozZiAntr = -1;
  var _inceputSapt = true;
  var _antrenamentComplet = false;
  var _continuaAntr = false;
  var _tipAntrenament = '';
  var _antrenamentFacut = false;

  Future<void> _getZiAntr() async {
    if (widget.exercitii != null && widget.exercitii!.length != 15) {
      setState(() {
        _continuaAntr = true;
      });
    } else if (widget.exercitii != null && widget.exercitii!.length == 15) {
      setState(() {
        _continuaAntr = false;
        _antrenamentComplet = true;
      });
    }
    var antrenamenteZiCurenta = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('antrenamente')
        .where('data',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .limit(1)
        .get();
    if (antrenamenteZiCurenta.docs.isNotEmpty) {
      setState(() {
        _antrenamentFacut = true;
      });
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists && snapshot.data()!.isNotEmpty) {
        if (snapshot.data()!.containsKey('zileAntrenament')) {
          setState(() {
            _zileActive = snapshot.data()!['zileAntrenament'];
          });
        }
      }
    });
    initializeDateFormatting('ro');

    DateTime now = DateTime.now();
    String currentDay = DateFormat('E', 'ro').format(now);
    if (_zileActive.contains(currentDay)) {
      setState(() {
        _ziAntr = true;
        _pozZiAntr = _zileActive.indexOf(currentDay);
      });
    }

    var snapshotAntrUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('antrenamente')
        .get();

    if (snapshotAntrUser.docs.isEmpty && (_pozZiAntr == 1 || _pozZiAntr == 2)) {
      setState(() {
        _inceputSapt = false;
      });
    }
    var antrSnapshot = await FirebaseFirestore.instance
        .collection('antrenamente')
        .where('zi', isEqualTo: _pozZiAntr + 1)
        .limit(1)
        .get();
    if (antrSnapshot.docs.isNotEmpty) {
      setState(() {
        _tipAntrenament = antrSnapshot.docs.first.get('nume');
      });
    }
  }

  Future<void> _getAntrenament() async {
    List<dynamic>? exercitii = [];
    var navigator = Navigator.of(context);
    if (widget.exercitii != null) {
      exercitii = widget.exercitii;
    }
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists && snapshot.data()!.isNotEmpty) {
      if (!snapshot.data()!.containsKey('greutateA1') && _pozZiAntr == 0) {
        var snapshot = await FirebaseFirestore.instance
            .collection('antrenamente')
            .where('zi', isEqualTo: 1)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          final nume = snapshot.docs.first.get('nume');
          final id1 = snapshot.docs.first.get('ex1');
          final id2 = snapshot.docs.first.get('ex2');
          final id3 = snapshot.docs.first.get('ex3');
          String exercitiu1 = '';
          String exercitiu2 = '';
          String exercitiu3 = '';

          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id1)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu1 = value.data()!['nume'];
              });
            }
          });
          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id2)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu2 = value.data()!['nume'];
              });
            }
          });
          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id3)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu3 = value.data()!['nume'];
              });
            }
          });
          if (exercitiu1 != '' && exercitiu2 != '' && exercitiu3 != '') {
            navigator.push(
              MaterialPageRoute(
                builder: (context) => EcranAlegereGreutate(
                    nume, exercitiu1, exercitiu2, exercitiu3),
              ),
            );
          }
        }
      } else if (!snapshot.data()!.containsKey('greutateB1') &&
          _pozZiAntr == 1) {
        var snapshot = await FirebaseFirestore.instance
            .collection('antrenamente')
            .where('zi', isEqualTo: 2)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          final nume = snapshot.docs.first.get('nume');
          final id1 = snapshot.docs.first.get('ex1');
          final id2 = snapshot.docs.first.get('ex2');
          final id3 = snapshot.docs.first.get('ex3');
          String exercitiu1 = '';
          String exercitiu2 = '';
          String exercitiu3 = '';

          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id1)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu1 = value.data()!['nume'];
              });
            }
          });
          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id2)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu2 = value.data()!['nume'];
              });
            }
          });
          await FirebaseFirestore.instance
              .collection('exercitii')
              .doc(id3)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                exercitiu3 = value.data()!['nume'];
              });
            }
          });
          if (exercitiu1 != '' && exercitiu2 != '' && exercitiu3 != '') {
            navigator.push(
              MaterialPageRoute(
                builder: (context) => EcranAlegereGreutate(
                    nume, exercitiu1, exercitiu2, exercitiu3),
              ),
            );
          }
        }
      } else {
        if (exercitii!.length < 5) {
          var antrSnapshot = await FirebaseFirestore.instance
              .collection('antrenamente')
              .where('zi', isEqualTo: _pozZiAntr + 1)
              .limit(1)
              .get();
          if (antrSnapshot.docs.isNotEmpty) {
            var ex1Snapshot = await FirebaseFirestore.instance
                .collection('exercitii')
                .doc(antrSnapshot.docs.first.get('ex1'))
                .get();
            if (ex1Snapshot.exists) {
              if (_pozZiAntr == 0 || _pozZiAntr == 2) {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex1Snapshot.data()!['nume'],
                        ex1Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateA1'],
                        exercitii),
                  ),
                );
              } else {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex1Snapshot.data()!['nume'],
                        ex1Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateB1'],
                        exercitii),
                  ),
                );
              }
            }
          }
        } else if (exercitii.length < 10) {
          var antrSnapshot = await FirebaseFirestore.instance
              .collection('antrenamente')
              .where('zi', isEqualTo: _pozZiAntr + 1)
              .limit(1)
              .get();
          if (antrSnapshot.docs.isNotEmpty) {
            var ex2Snapshot = await FirebaseFirestore.instance
                .collection('exercitii')
                .doc(antrSnapshot.docs.first.get('ex2'))
                .get();
            if (ex2Snapshot.exists) {
              if (_pozZiAntr == 0 || _pozZiAntr == 2) {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex2Snapshot.data()!['nume'],
                        ex2Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateA2'],
                        exercitii),
                  ),
                );
              } else {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex2Snapshot.data()!['nume'],
                        ex2Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateB2'],
                        exercitii),
                  ),
                );
              }
            }
          }
        } else if (exercitii.length < 15) {
          var antrSnapshot = await FirebaseFirestore.instance
              .collection('antrenamente')
              .where('zi', isEqualTo: _pozZiAntr + 1)
              .limit(1)
              .get();
          if (antrSnapshot.docs.isNotEmpty) {
            var ex3Snapshot = await FirebaseFirestore.instance
                .collection('exercitii')
                .doc(antrSnapshot.docs.first.get('ex3'))
                .get();
            if (ex3Snapshot.exists) {
              if (_pozZiAntr == 0 || _pozZiAntr == 2) {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex3Snapshot.data()!['nume'],
                        ex3Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateA3'],
                        exercitii),
                  ),
                );
              } else {
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EcranExercitiu(
                        antrSnapshot.docs.first.get('nume'),
                        ex3Snapshot.data()!['nume'],
                        ex3Snapshot.data()!['imagine'],
                        snapshot.data()!['greutateB3'],
                        exercitii),
                  ),
                );
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getZiAntr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Antrenament'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: _zileActive.isNotEmpty
                ? Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      !_inceputSapt
                          ? Column(
                              children: [
                                const Text(
                                  'Antrenamentele se încep cu prima zi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Reveniți ${_zileActive.elementAt(0)}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          : _ziAntr
                              ? _antrenamentFacut
                                  ? Column(
                                      children: const [
                                        Text(
                                          'Ai făcut deja antrenamentul pe ziua de azi.',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'Bucură-te de odihnă!',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    )
                                  : _antrenamentComplet
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EcranFeedback(
                                                        _tipAntrenament,
                                                        widget.exercitii),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                              'Termina antrenamentul'),
                                        )
                                      : ElevatedButton(
                                          onPressed: _getAntrenament,
                                          child: Text(_continuaAntr
                                              ? 'Exercitiul urmator'
                                              : 'Start antrenament'),
                                        )
                              : Column(
                                  children: const [
                                    Text(
                                      'Nu e ziua de antrenament.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      'Bucură-te de odihnă!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                      const Expanded(child: SizedBox()),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            var navigator = Navigator.of(context);

                            navigator.push(MaterialPageRoute(
                                builder: (context) =>
                                    const EcranAlegereZile()));
                          },
                          child: const Text('Alegere zile de antrenament')),
                    ],
                  ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

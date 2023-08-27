import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:intl/intl.dart';

class EcranFeedback extends StatefulWidget {
  final List<dynamic>? exercitii;
  final String tipAntr;

  const EcranFeedback(this.tipAntr, this.exercitii, {super.key});

  @override
  State<EcranFeedback> createState() => _EcranFeedbackState();
}

class _EcranFeedbackState extends State<EcranFeedback> {
  var _greutate1 = '';
  var _greutate2 = '';
  var _greutate3 = '';
  Future<void> _salveazaFeedback(String text) async {
    var navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('antrenamente')
        .add({
      'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'exercitii': widget.exercitii,
    });
    if (widget.tipAntr == 'Antrenament A') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists && value.data()!.isNotEmpty) {
          setState(() {
            _greutate1 = value.data()!['greutateA1'] ?? '';
            _greutate2 = value.data()!['greutateA2'] ?? '';
            _greutate3 = value.data()!['greutateA3'] ?? '';
          });
        }
      });

      if (text == 'pozitiv') {
        setState(() {
          _greutate1 = (double.parse(_greutate1) + 2).toString();
          _greutate2 = (double.parse(_greutate2) + 2).toString();
          _greutate3 = (double.parse(_greutate3) + 2).toString();
        });
      } else {
        setState(() {
          _greutate1 = (double.parse(_greutate1) - 2).toString();
          _greutate2 = (double.parse(_greutate2) - 2).toString();
          _greutate3 = (double.parse(_greutate3) - 2).toString();
        });
      }

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
          .get()
          .then((value) {
        if (value.exists && value.data()!.isNotEmpty) {
          setState(() {
            _greutate1 = value.data()!['greutateB1'] ?? '';
            _greutate2 = value.data()!['greutateB2'] ?? '';
            _greutate3 = value.data()!['greutateB3'] ?? '';
          });
        }
      });
      if (text == 'pozitiv') {
        setState(() {
          _greutate1 = (double.parse(_greutate1) + 2.0).toString();
          _greutate2 = (double.parse(_greutate2) + 2.0).toString();
          _greutate3 = (double.parse(_greutate3) + 2.0).toString();
        });
      } else {
        setState(() {
          var g1 = double.parse(_greutate1) - 2.0;
          var g2 = double.parse(_greutate2) - 2.0;
          var g3 = double.parse(_greutate3) - 2.0;
          if (g1 <= 0.0) {
            g1 = 0.0;
          }
          if (g2 <= 0.0) {
            g2 = 0.0;
          }
          if (g3 <= 0.0) {
            g3 = 0.0;
          }
          _greutate1 = g1.toString();
          _greutate2 = g2.toString();
          _greutate3 = g3.toString();
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'greutateB1': _greutate1,
        'greutateB2': _greutate2,
        'greutateB3': _greutate3,
      });
    }
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers(''),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Cum a decurs antrenamentul?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          _salveazaFeedback('pozitiv');
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.sentiment_very_satisfied),
                            Text('Bine'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {
                            _salveazaFeedback('negativ');
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.sentiment_very_dissatisfied),
                              Text('Cam greu')
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

import 'package:all_you_need/ecrane/profil/ecran_detalii_personale.dart';
import 'package:all_you_need/ecrane/profil/ecran_masuratori.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EcranHidratare extends StatefulWidget {
  static const routeName = '/hidratare';
  const EcranHidratare({super.key});

  @override
  State<EcranHidratare> createState() => _EcranHidratareState();
}

class _EcranHidratareState extends State<EcranHidratare> {
  var _nivelHidratare = 0;
  var _procent = 0.0;
  var _necesarLichide = -1;
  var _gen = '-';

  Future<void> _getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _necesarLichide = value.data()!['necesarLichide'] ?? -1;
        _gen = value.data()!['gen'].toString();
      });
    });
    //Daca nu exista deja colectia, o creez cu un document initial
    final waterCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('apa');
    final waterCollectionSnapshot = await waterCollectionRef.get();
    if (waterCollectionSnapshot.docs.isEmpty) {
      await waterCollectionRef.add({
        'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'cantitateApa': _nivelHidratare,
      });
    }
    _salveaza(0);
  }

  void _salveaza(int cantitate) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('apa')
        .where('data',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      //Actualizez cantitatea de apa din ziua respectiva
      final documentId = snapshot.docs.first.id;
      final nivelCurent = snapshot.docs.first.get('cantitateApa') as int;
      final nivelNou = nivelCurent + cantitate;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('apa')
          .doc(documentId)
          .update({'cantitateApa': nivelNou});
      setState(() {
        _nivelHidratare = nivelNou;
        _procent = _nivelHidratare / _necesarLichide;
      });
    } else {
      //Creez un document nou pentru ziua respectiva cu valoarea initiala 0
      await FirebaseFirestore.instance
          .collection('users')
          .doc((FirebaseAuth.instance.currentUser!).uid)
          .collection('apa')
          .add({
        'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'cantitateApa': _nivelHidratare,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Monitorizare consum apa'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: _necesarLichide == -1
                ? Center(
                    child: _gen != '-'
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EcranMasuratori.routeName);
                            },
                            child: const Text(
                              'Introduceti intai masuratorile!',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EcranDetaliiPersonale.routeName);
                            },
                            child: const Text('Completati intai profilul!'),
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Nivel de hidratare curent',
                        style: TextStyle(fontSize: 20),
                      ),
                      CircularPercentIndicator(
                        radius: 150,
                        lineWidth: 15,
                        percent: _procent > 1 ? 1 : _procent,
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.5),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(_procent * 100).truncate()}%',
                              style: const TextStyle(fontSize: 50),
                            ),
                            Text(
                              '$_nivelHidratare ml',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Text(_necesarLichide - _nivelHidratare <= 0
                          ? 'Ai consumat cu ${_nivelHidratare - _necesarLichide} ml mai mult decat necesarul de $_necesarLichide ml.'
                          : 'Cantitatea de apa care mai trebuie consumata: ${_necesarLichide - _nivelHidratare} ml'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _salveaza(250);
                            },
                            icon: Icon(
                              Icons.local_drink,
                              color: HexColor('1E90FF'),
                            ),
                            label: const Text('250 ml'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _salveaza(500);
                            },
                            icon: Icon(
                              Icons.local_drink,
                              color: HexColor('1E90FF'),
                            ),
                            label: const Text('500 ml'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                            ),
                          ),
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

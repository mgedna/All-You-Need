import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:intl/intl.dart';

class EcranMacroAlimentatie extends StatefulWidget {
  const EcranMacroAlimentatie({super.key});

  @override
  State<EcranMacroAlimentatie> createState() => _EcranMacroAlimentatieState();
}

class _EcranMacroAlimentatieState extends State<EcranMacroAlimentatie> {
  var _proteineConsumate = '0';
  var _carboConsumate = '0';
  var _grasimiConsumate = '0';
  var _fibreConsumate = '0';
  var _necesarProteine = '-1';
  var _necesarCarbo = '-1';
  var _necesarGrasimi = '-1';
  var _necesarFibre = '-1';

  DateTime data = DateTime.now();
  int _indexZiCurenta = 0;
  String _dataAfisata = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime primaData = DateTime.now();

  Future<void> _getDate() async {
    var first = await getFirstDate();
    setState(() {
      if (first != null) {
        primaData = first;
      }
    });

    final colAlimRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alimentatie');

    final snapshot = await colAlimRef
        .where('data',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final protConsCurent = snapshot.docs.first.get('cantitateProteine');
      final carboConsCurent = snapshot.docs.first.get('cantitateCarbo');
      final grasimiConsCurent = snapshot.docs.first.get('cantitateGrasimi');
      final fibreConsCurent = snapshot.docs.first.get('cantitateFibre');
      final protObiectiv = snapshot.docs.first.get('necesarProteine');
      final carboObiectiv = snapshot.docs.first.get('necesarCarbohidrati');
      final grasimiObiectiv = snapshot.docs.first.get('necesarGrasimi');
      final fibreObiectiv = snapshot.docs.first.get('necesarFibre');

      setState(() {
        _proteineConsumate = protConsCurent.round().toString();
        _carboConsumate = carboConsCurent.round().toString();
        _grasimiConsumate = grasimiConsCurent.round().toString();
        _fibreConsumate = fibreConsCurent.round().toString();
        _necesarProteine = protObiectiv.toString();
        _necesarCarbo = carboObiectiv.toString();
        _necesarGrasimi = grasimiObiectiv.toString();
        _necesarFibre = fibreObiectiv.toString();
      });
    }
  }

  Future<void> _updateUI() async {
    final colAlimRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alimentatie');
    final colAlimSnapshot = await colAlimRef.get();
    if (colAlimSnapshot.docs.isNotEmpty) {
      final snapshot = await colAlimRef
          .where('data', isEqualTo: _dataAfisata)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final protCons = snapshot.docs.first.get('cantitateProteine');
        final carboCons = snapshot.docs.first.get('cantitateCarbo');
        final grasimiCons = snapshot.docs.first.get('cantitateGrasimi');
        final fibreCons = snapshot.docs.first.get('cantitateFibre');
        setState(() {
          _proteineConsumate = protCons.toString();
          _carboConsumate = carboCons.toString();
          _grasimiConsumate = grasimiCons.toString();
          _fibreConsumate = fibreCons.toString();
        });
      } else {
        if (_indexZiCurenta == -1) {
          goToPreviousDay();
        } else if (_indexZiCurenta == 1) {
          goToNextDay();
        }
      }
    }
  }

  Future<DateTime?> getFirstDate() async {
    try {
      final querySnapshot = await queryCollection();
      if (querySnapshot.isNotEmpty) {
        final firstDocument = querySnapshot.first;
        final timestamp = firstDocument['data'];
        return DateFormat('dd/MM/yyyy').parse(timestamp);
      } else {
        return null; // Return null if the collection is empty
      }
    } catch (e) {
      // print('Eroare in accesarea primei dati: $e');
      return null; // Return null in case of an error
    }
  }

  Future<List<QueryDocumentSnapshot>> queryCollection() async {
    try {
      final alimentatieSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .get();
      return alimentatieSnapshot.docs;
    } catch (e) {
      // print('Eroare in interogarea colectie: $e');
      return [];
    }
  }

  void goToPreviousDay() {
    var dataNoua = data.subtract(const Duration(days: 1));

    if (dataNoua.compareTo(primaData) > 0) {
      setState(() {
        data = dataNoua;
        _dataAfisata = DateFormat('dd/MM/yyyy').format(data);
      });
      _updateUI();
    }
  }

  void goToNextDay() {
    if (_dataAfisata != DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      setState(() {
        data = data.add(const Duration(days: 1));
        _dataAfisata = DateFormat('dd/MM/yyyy').format(data);
      });
      _updateUI();
    }
  }

  @override
  void initState() {
    super.initState();
    _getDate();
    setState(() {
      data = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Monitorizare alimentatie'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _indexZiCurenta = -1;
                          });
                          goToPreviousDay();
                        },
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Text(
                        _dataAfisata ==
                                DateFormat('dd/MM/yyyy').format(DateTime.now())
                            ? 'Astazi'
                            : _dataAfisata,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _indexZiCurenta = 1;
                          });
                          goToNextDay();
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  const Divider(thickness: 5),
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Total'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Obiectiv'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Ramas'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 55, right: 55),
                            child: Text('Proteine'),
                          ),
                          Text('${_proteineConsumate}g'),
                          Text('${double.parse(_necesarProteine).round()}g'),
                          Text(
                              '${(double.parse(_necesarProteine) - double.parse(_proteineConsumate)).round()}g'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 45, right: 50),
                            child: Text('Carbohidrati'),
                          ),
                          Text('${_carboConsumate}g'),
                          Text('${double.parse(_necesarCarbo).round()}g'),
                          Text(
                              '${(double.parse(_necesarCarbo) - double.parse(_carboConsumate)).round()}g'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 55, right: 55),
                            child: Text('Grasimi'),
                          ),
                          Text('${_grasimiConsumate}g'),
                          Text('${double.parse(_necesarGrasimi).round()}g'),
                          Text(
                              '${(double.parse(_necesarGrasimi) - double.parse(_grasimiConsumate)).round()}g'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 60,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 60, right: 70),
                            child: Text('Fibre'),
                          ),
                          Text('${_fibreConsumate}g'),
                          Text('${double.parse(_necesarFibre).round()}g'),
                          Text(
                              '${(double.parse(_necesarFibre) - double.parse(_fibreConsumate)).round()}g'),
                        ],
                      ),
                    ),
                  ),
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

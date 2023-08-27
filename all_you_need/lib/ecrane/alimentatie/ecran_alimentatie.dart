import 'package:all_you_need/ecrane/alimentatie/ecran_macro_alimentatie.dart';
import 'package:all_you_need/ecrane/profil/ecran_detalii_personale.dart';
import 'package:all_you_need/ecrane/profil/ecran_masuratori.dart';
import 'package:all_you_need/widgets/alimentatie/widget_mesele_zilei.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:intl/intl.dart';

class EcranAlimentatie extends StatefulWidget {
  static const routeName = '/alimentatie';
  const EcranAlimentatie({super.key});

  @override
  State<EcranAlimentatie> createState() => _EcranAlimentatieState();
}

class _EcranAlimentatieState extends State<EcranAlimentatie> {
  var _necesarCaloric = '-1';
  var _necesarProteine = '-1';
  var _necesarCarbo = '-1';
  var _necesarGrasimi = '-1';
  var _necesarFibre = '-1';

  var _caloriiConsumate = '0';

  var _caloriiRamase = '-1';
  double _caloriiConsMd = 0.0;
  double _caloriiConsPranz = 0.0;
  double _caloriiConsCina = 0.0;
  var _alimenteCina = [];
  var _alimentePranz = [];
  var _alimenteMd = [];
  String _documentId = '';
  DateTime data = DateTime.now();
  int _indexZiCurenta = 0;
  String _dataAfisata = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime primaData = DateTime.now();
  var _gen = '';

  Future<void> _getDate() async {
    var prima = await primaZi();
    setState(() {
      if (prima != null) {
        primaData = prima;
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _gen = value.data()!['gen'];
        _necesarCaloric = value.data()!['necesarCaloric'].toString();
        _necesarProteine = value.data()!['necesarProteine'].toString();
        _necesarCarbo = value.data()!['necesarCarbohidrati'].toString();
        _necesarGrasimi = value.data()!['necesarGrasimi'].toString();
        _necesarFibre = value.data()!['necesarFibre'].toString();
        _caloriiRamase =
            (int.parse(_necesarCaloric) - int.parse(_caloriiConsumate))
                .toString();
      });
    });
    if (_gen != '' && _necesarCaloric != '-1') {
      final colAlimRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie');
      final colAlimSnapshot = await colAlimRef.get();
      if (colAlimSnapshot.docs.isEmpty) {
        final newDocRef = await colAlimRef.add({
          'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          'caloriiConsumate': 0.0,
          'cantitateProteine': 0.0,
          'cantitateCarbo': 0.0,
          'cantitateGrasimi': 0.0,
          'cantitateFibre': 0.0,
          'necesarCaloric': double.parse(_necesarCaloric),
          'necesarProteine': double.parse(_necesarProteine),
          'necesarCarbohidrati': double.parse(_necesarCarbo),
          'necesarGrasimi': double.parse(_necesarGrasimi),
          'necesarFibre': double.parse(_necesarFibre),
        });
        setState(() {
          _documentId = newDocRef.id;
        });
        List<String> idAlimente = [];
        final micDejunRef = colAlimRef.doc(newDocRef.id).collection('micDejun');
        await micDejunRef.add({
          'caloriiConsumate': _caloriiConsMd,
          'alimenteConsumate': idAlimente
        });

        final pranzRef = colAlimRef.doc(newDocRef.id).collection('pranz');
        await pranzRef.add({
          'caloriiConsumate': _caloriiConsPranz,
          'alimenteConsumate': idAlimente
        });

        final cinaRef = colAlimRef.doc(newDocRef.id).collection('cina');
        await cinaRef.add({
          'caloriiConsumate': _caloriiConsCina,
          'alimenteConsumate': idAlimente
        });
      } else {
        final snapshot = await colAlimRef
            .where('data',
                isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          final calConsCurent = snapshot.docs.first.get('caloriiConsumate');

          final docId = snapshot.docs.first.id;
          final mdSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('alimentatie')
              .doc(docId)
              .collection('micDejun')
              .limit(1)
              .get();
          final calMd = mdSnapshot.docs.first.get('caloriiConsumate') as double;
          final alimenteMd = mdSnapshot.docs.first.get('alimenteConsumate');

          final pranzSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('alimentatie')
              .doc(docId)
              .collection('pranz')
              .limit(1)
              .get();
          final calPranz =
              pranzSnapshot.docs.first.get('caloriiConsumate') as double;
          final alimentePranz =
              pranzSnapshot.docs.first.get('alimenteConsumate');

          final cinaSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('alimentatie')
              .doc(docId)
              .collection('cina')
              .limit(1)
              .get();
          final calCina =
              cinaSnapshot.docs.first.get('caloriiConsumate') as double;
          final alimenteCina = cinaSnapshot.docs.first.get('alimenteConsumate');
          setState(() {
            _caloriiConsumate = calConsCurent.round().toString();

            _caloriiRamase =
                (double.parse(_necesarCaloric) - calConsCurent.round())
                    .round()
                    .toString();
            _caloriiConsMd = calMd;
            _caloriiConsPranz = calPranz;
            _caloriiConsCina = calCina;
            _alimenteCina = alimenteCina;
            _alimenteMd = alimenteMd;
            _alimentePranz = alimentePranz;
          });
        } else {
          //Creez un document nou pentru ziua respectiva cu valoarea initiala 0
          final docRefNou = await colAlimRef.add({
            'data': DateFormat('dd/MM/yyyy').format(DateTime.now()),
            'caloriiConsumate': 0.0,
            'cantitateProteine': 0.0,
            'cantitateCarbo': 0.0,
            'cantitateGrasimi': 0.0,
            'cantitateFibre': 0.0,
            'necesarCaloric': double.parse(_necesarCaloric),
            'necesarProteine': double.parse(_necesarProteine),
            'necesarCarbohidrati': double.parse(_necesarCarbo),
            'necesarGrasimi': double.parse(_necesarGrasimi),
            'necesarFibre': double.parse(_necesarFibre),
          });
          setState(() {
            _documentId = docRefNou.id;
          });
          List<String> idAlimente = [];
          final micDejunRef =
              colAlimRef.doc(docRefNou.id).collection('micDejun');
          await micDejunRef.add({
            'caloriiConsumate': _caloriiConsMd,
            'alimenteConsumate': idAlimente
          });

          final pranzRef = colAlimRef.doc(docRefNou.id).collection('pranz');
          await pranzRef.add({
            'caloriiConsumate': _caloriiConsPranz,
            'alimenteConsumate': idAlimente
          });

          final cinaRef = colAlimRef.doc(docRefNou.id).collection('cina');
          await cinaRef.add({
            'caloriiConsumate': _caloriiConsCina,
            'alimenteConsumate': idAlimente
          });
        }
      }
    }
  }

  Future<void> _actualizeazaUI() async {
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
        setState(() {
          _documentId = snapshot.docs.first.id;
        });
        final necesCal = snapshot.docs.first.get('necesarCaloric');
        final calConsCurent = snapshot.docs.first.get('caloriiConsumate');
        final mdSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('alimentatie')
            .doc(_documentId)
            .collection('micDejun')
            .limit(1)
            .get();
        final calMd = mdSnapshot.docs.first.get('caloriiConsumate') as double;
        final alimenteMd = mdSnapshot.docs.first.get('alimenteConsumate');

        final pranzSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('alimentatie')
            .doc(_documentId)
            .collection('pranz')
            .limit(1)
            .get();
        final calPranz =
            pranzSnapshot.docs.first.get('caloriiConsumate') as double;
        final alimentePranz = pranzSnapshot.docs.first.get('alimenteConsumate');

        final cinaSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('alimentatie')
            .doc(_documentId)
            .collection('cina')
            .limit(1)
            .get();
        final calCina =
            cinaSnapshot.docs.first.get('caloriiConsumate') as double;
        final alimenteCina = cinaSnapshot.docs.first.get('alimenteConsumate');
        setState(() {
          _necesarCaloric = necesCal.toString();
          _caloriiConsumate = calConsCurent.round().toString();
          _caloriiRamase =
              (double.parse(_necesarCaloric) - calConsCurent.round())
                  .round()
                  .toString();
          _caloriiConsMd = calMd;
          _caloriiConsPranz = calPranz;
          _caloriiConsCina = calCina;
          _alimenteCina = alimenteCina;
          _alimenteMd = alimenteMd;
          _alimentePranz = alimentePranz;
        });
      } else {
        if (_indexZiCurenta == -1) {
          ziuaAnterioara();
        } else if (_indexZiCurenta == 1) {
          ziuaUrmatoare();
        }
      }
    }
  }

  Future<DateTime?> primaZi() async {
    try {
      final querySnapshot = await docAlimentatie();
      if (querySnapshot.isNotEmpty) {
        final firstDocument = querySnapshot.first;
        final timestamp = firstDocument['data'];
        return DateFormat('dd/MM/yyyy').parse(timestamp);
      } else {
        return null; // colectia e goala
      }
    } catch (e) {
      // print('Eroare in accesarea primei zile: $e');
      return null; // eroare
    }
  }

  Future<List<QueryDocumentSnapshot>> docAlimentatie() async {
    try {
      final alimentatieSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .get();
      return alimentatieSnapshot.docs;
    } catch (e) {
      // print('Eroare in interogarea colectiei: $e');
      return [];
    }
  }

  void ziuaAnterioara() async {
    var dataNoua = data.subtract(const Duration(days: 1));
    if (dataNoua.compareTo(primaData) > 0) {
      setState(() {
        data = dataNoua;
        _dataAfisata = DateFormat('dd/MM/yyyy').format(data);
      });
      _actualizeazaUI();
    }
  }

  void ziuaUrmatoare() {
    if (_dataAfisata != DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      setState(() {
        data = data.add(const Duration(days: 1));
        _dataAfisata = DateFormat('dd/MM/yyyy').format(data);
      });
      _actualizeazaUI();
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
      body: _gen == ''
          ? Column(
              children: [
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(EcranDetaliiPersonale.routeName);
                  },
                  child: const Text('Completati intai datele personale!'),
                ),
                const Expanded(child: SizedBox()),
                const BaraNavigare(),
              ],
            )
          : _necesarCaloric == '-1'
              ? Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(EcranMasuratori.routeName);
                      },
                      child: const Text('Completati intai masuratorile.'),
                    ),
                    const Expanded(child: SizedBox()),
                    const BaraNavigare(),
                  ],
                )
              : Column(
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
                                    ziuaAnterioara();
                                  },
                                  child: const Icon(Icons.arrow_back_ios_new),
                                ),
                                Text(
                                  _dataAfisata ==
                                          DateFormat('dd/MM/yyyy')
                                              .format(DateTime.now())
                                      ? 'Astazi'
                                      : _dataAfisata,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _indexZiCurenta = 1;
                                    });
                                    ziuaUrmatoare();
                                  },
                                  child: const Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                            const Divider(thickness: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EcranMacroAlimentatie(),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Calorii ramase',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                _necesarCaloric,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Obiectiv',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            '-',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                _caloriiConsumate,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Consumate',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            '=',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                _caloriiRamase,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Ramase',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            WidgetMeseleZilei('Micul dejun',
                                _caloriiConsMd.toString(), _alimenteMd),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WidgetMeseleZilei('Pranz',
                                _caloriiConsPranz.toString(), _alimentePranz),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WidgetMeseleZilei('Cina',
                                _caloriiConsCina.toString(), _alimenteCina),
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

import 'package:all_you_need/ecrane/alimentatie/ecran_alimentatie.dart';
import 'package:all_you_need/modele/aliment.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class EcranDetaliiAliment extends StatefulWidget {
  final dynamic nrPortii;
  final String metoda;
  const EcranDetaliiAliment(this.aliment, this.masa,
      {super.key, this.nrPortii = '1.0', this.metoda = 'Adauga'});

  final Aliment aliment;
  final String masa;

  @override
  State<EcranDetaliiAliment> createState() => _EcranDetaliiAlimentState();
}

class _EcranDetaliiAlimentState extends State<EcranDetaliiAliment> {
  var _nrPortii = '1.0';
  var _stergere = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nrPortii = widget.nrPortii;
    });
  }

  Future<void> _salveaza() async {
    if (widget.metoda == 'Actualizeaza') {
      await _sterge();
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alimentatie')
        .where('data',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final documentId = snapshot.docs.first.id;
      final nivelCurent = snapshot.docs.first.get('caloriiConsumate') as double;
      final nivelProteineCurent =
          snapshot.docs.first.get('cantitateProteine') as double;
      final nivelCarboCurent =
          snapshot.docs.first.get('cantitateCarbo') as double;
      final nivelGrasimiCurent =
          snapshot.docs.first.get('cantitateGrasimi') as double;
      final nivelFibreCurent =
          snapshot.docs.first.get('cantitateFibre') as double;
      final nivelNou =
          nivelCurent + double.parse(_nrPortii) * widget.aliment.calorii;

      final nivelNouProteine = nivelProteineCurent +
          double.parse(_nrPortii) * widget.aliment.proteine;
      final nivelNouCarbo =
          nivelCarboCurent + double.parse(_nrPortii) * widget.aliment.carbs;
      final nivelNouGrasimi =
          nivelGrasimiCurent + double.parse(_nrPortii) * widget.aliment.grasimi;
      final nivelNouFibre =
          nivelFibreCurent + double.parse(_nrPortii) * widget.aliment.fibre;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .doc(documentId)
          .update({
        'caloriiConsumate': nivelNou,
        'cantitateProteine': nivelNouProteine.roundToDouble(),
        'cantitateCarbo': nivelNouCarbo.roundToDouble(),
        'cantitateGrasimi': nivelNouGrasimi.roundToDouble(),
        'cantitateFibre': nivelNouFibre.roundToDouble(),
      });
      final masaSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .doc(documentId)
          .collection(widget.masa)
          .limit(1)
          .get();
      if (masaSnapshot.docs.isNotEmpty) {
        final docId = masaSnapshot.docs.first.id;
        final calConsCurent =
            masaSnapshot.docs.first.get('caloriiConsumate') as double;
        final calConsNou =
            calConsCurent + double.parse(_nrPortii) * widget.aliment.calorii;
        final alimenteCons =
            masaSnapshot.docs.first.get('alimenteConsumate') as List<dynamic>;
        Map<String, dynamic> alimentEntry = {
          'id': widget.aliment.id,
          'nume': widget.aliment.nume,
          'calorii': double.parse(_nrPortii) * widget.aliment.calorii
        };
        alimenteCons.add(alimentEntry);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('alimentatie')
            .doc(documentId)
            .collection(widget.masa)
            .doc(docId)
            .update({
          'caloriiConsumate': calConsNou,
          'alimenteConsumate': alimenteCons
        });
      }
    }
  }

  Future<void> _sterge() async {
    var navigator = Navigator.of(context);
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('alimentatie')
        .where('data',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final documentId = snapshot.docs.first.id;
      final nivelCurent = snapshot.docs.first.get('caloriiConsumate') as double;
      final nivelProteineCurent =
          snapshot.docs.first.get('cantitateProteine') as double;
      final nivelCarboCurent =
          snapshot.docs.first.get('cantitateCarbo') as double;
      final nivelGrasimiCurent =
          snapshot.docs.first.get('cantitateGrasimi') as double;
      final nivelFibreCurent =
          snapshot.docs.first.get('cantitateFibre') as double;
      final nivelNou =
          nivelCurent - double.parse(widget.nrPortii) * widget.aliment.calorii;
      final nivelNouProteine = nivelProteineCurent -
          double.parse(widget.nrPortii) * widget.aliment.proteine;
      final nivelNouCarbo = nivelCarboCurent -
          double.parse(widget.nrPortii) * widget.aliment.carbs;
      final nivelNouGrasimi = nivelGrasimiCurent -
          double.parse(widget.nrPortii) * widget.aliment.grasimi;
      final nivelNouFibre = nivelFibreCurent -
          double.parse(widget.nrPortii) * widget.aliment.fibre;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .doc(documentId)
          .update({
        'caloriiConsumate': nivelNou,
        'cantitateProteine': nivelNouProteine.roundToDouble(),
        'cantitateCarbo': nivelNouCarbo.roundToDouble(),
        'cantitateGrasimi': nivelNouGrasimi.roundToDouble(),
        'cantitateFibre': nivelNouFibre.roundToDouble(),
      });
      final masaSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alimentatie')
          .doc(documentId)
          .collection(widget.masa)
          .limit(1)
          .get();
      if (masaSnapshot.docs.isNotEmpty) {
        final docId = masaSnapshot.docs.first.id;
        final calConsCurent =
            masaSnapshot.docs.first.get('caloriiConsumate') as double;
        final calConsNou = calConsCurent -
            double.parse(widget.nrPortii) * widget.aliment.calorii;
        final alimenteCons =
            masaSnapshot.docs.first.get('alimenteConsumate') as List<dynamic>;
        final indexToRemove = alimenteCons.indexWhere((element) =>
            element['id'] == widget.aliment.id &&
            element['nume'] == widget.aliment.nume &&
            element['calorii'] ==
                double.parse(widget.nrPortii) * widget.aliment.calorii);

        if (indexToRemove != -1) {
          alimenteCons.removeAt(indexToRemove);
          if (alimenteCons.isEmpty) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('alimentatie')
                .doc(documentId)
                .update({
              'caloriiConsumate': 0.0,
              'cantitateProteine': 0.0,
              'cantitateCarbo': 0.0,
              'cantitateGrasimi': 0.0,
              'cantitateFibre': 0.0,
            });
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('alimentatie')
            .doc(documentId)
            .collection(widget.masa)
            .doc(docId)
            .update({
          'caloriiConsumate': calConsNou,
          'alimenteConsumate': alimenteCons
        });
        if (_stergere) {
          navigator.popUntil((route) => route.isFirst);
          navigator.pushNamed(EcranAlimentatie.routeName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.metoda == 'Adauga'
            ? 'Adauga aliment'
            : 'Actualizeaza aliment'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          GestureDetector(
            onTap: () async {
              var navigator = Navigator.of(context);
              await _salveaza();
              navigator.popUntil((route) => route.isFirst);
              navigator.pushNamed(EcranAlimentatie.routeName);
            },
            child: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                child: FadeInImage(
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: NetworkImage(widget.aliment.imageUrl),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit
                                      .cover, //pt a nu avea imagine distorsionata
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.aliment.nume,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Brand: ${widget.aliment.brand}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          child: Row(
                            children: [
                              const Text(
                                'Numar de portii',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const Expanded(child: Text('')),
                              GestureDetector(
                                child: Text(_nrPortii),
                                onTap: () {
                                  _controller =
                                      TextEditingController(text: _nrPortii);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Introduceti numarul de portii'),
                                        content: TextField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,3}$'),
                                            ),
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          controller: _controller,
                                          decoration: const InputDecoration(
                                            hintText: 'Numar de portii',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Anuleaza'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              String text = _controller.text;
                                              if (text.isNotEmpty) {
                                                double? valoare =
                                                    double.tryParse(text);
                                                if (valoare != null) {
                                                  setState(() {
                                                    _nrPortii = text;
                                                  });
                                                  Navigator.of(context).pop();
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Eroare'),
                                                        content: const Text(
                                                            'Introduceti un numar valid.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                            child: const Text('Salveaza'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          child: Row(
                            children: const [
                              Text(
                                'Cantitate',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Expanded(child: Text('')),
                              Text('100g'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: HexColor('F0EEEE'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Calorii',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${(double.parse(_nrPortii) * widget.aliment.calorii).roundToDouble()}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Proteine',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${(double.parse(_nrPortii) * widget.aliment.proteine).roundToDouble()}g',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Carbohidrati',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${(double.parse(_nrPortii) * widget.aliment.carbs).roundToDouble()}g',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Grasimi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${(double.parse(_nrPortii) * widget.aliment.grasimi).roundToDouble()}g',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Fibre',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${(double.parse(_nrPortii) * widget.aliment.fibre).roundToDouble()}g',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.metoda == 'Actualizeaza')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stergere = true;
                  });
                  _sterge();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.delete),
                    Text('Sterge alimentul'),
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

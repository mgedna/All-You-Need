import 'package:all_you_need/ecrane/profil/ecran_detalii_personale.dart';
import 'package:all_you_need/ecrane/profil/ecran_masuratori.dart';
import 'package:all_you_need/helpers/calculator_body_fat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class EcranProfil extends StatefulWidget {
  static const routeName = '/profil';
  final bool seSalveaza;

  const EcranProfil({this.seSalveaza = false, super.key});

  @override
  State<EcranProfil> createState() => _EcranProfilState();
}

class _EcranProfilState extends State<EcranProfil> {
  late String _gen;
  String _procent = '-1';
  late String _interpretare;
  late String _necesarCaloric = '-1';
  Future<void> _getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _gen = value.data()!['gen'].toString();
        _procent = value.data()!['bodyFat'].toString();
        _necesarCaloric = value.data()!['necesarCaloric'].toString();
        _interpretare =
            CalculatorBodyFat.interpretare(_gen, int.parse(_procent));
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: HexColor('030303'),
      ),
      drawer: const Meniu(),
      body: Center(
        child: FutureBuilder(
            future: Future.delayed(
                const Duration(seconds: 1), () => widget.seSalveaza),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          if (userData == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.only(top: 5, left: 2),
                            height: size.height / 5,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(userData['pozaProfil']),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData['username'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            EcranDetaliiPersonale.routeName);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height / 5,
                              child: GestureDetector(
                                onTap: () {
                                  _getDate();
                                  if (_gen != '-') {
                                    Navigator.of(context).pushReplacementNamed(
                                        EcranMasuratori.routeName);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            content: const Text(
                                                'Completati intai profilul.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); //pt AlertDialog
                                                  Navigator.of(context).pushNamed(
                                                      EcranDetaliiPersonale
                                                          .routeName); //pt Pagina de detalii personale
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.monitor_weight,
                                            size: 45,
                                            color: HexColor('1E90FF')),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Măsurători',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      color: HexColor('F0EEEE'),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Necesar caloric',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          _necesarCaloric == '-1'
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      'Introduceti',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'masuratorile',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Text(
                                                      _necesarCaloric,
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'kcal/zi',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      color: HexColor('F0EEEE'),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Grăsime corporală',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          _procent == '-1'
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      'Introduceti',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'masuratorile',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Text(
                                                      '$_procent%',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      _interpretare,
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const BaraNavigare(),
                  ],
                );
              }
            }),
      ),
    );
  }
}

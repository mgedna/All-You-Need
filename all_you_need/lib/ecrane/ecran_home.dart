import 'package:all_you_need/ecrane/alimentatie/ecran_alimentatie.dart';
import 'package:all_you_need/ecrane/antrenament/ecran_antrenament.dart';
import 'package:all_you_need/ecrane/ecran_bodyfat.dart';
import 'package:all_you_need/ecrane/ecran_hidratare.dart';
import 'package:all_you_need/ecrane/retete/ecran_retete.dart';
import 'package:all_you_need/ecrane/ecran_sanatate.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/home/card_home.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class EcranHome extends StatefulWidget {
  static const routeName = '/home';
  const EcranHome({super.key});

  @override
  State<EcranHome> createState() => _EcranHomeState();
}

class _EcranHomeState extends State<EcranHome> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AppBarPers(''),
      drawer: const Meniu(),
      body: StreamBuilder<DocumentSnapshot>(
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
            var userData = snapshot.data!.data() as Map<String, dynamic>?;
            if (userData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var username = userData['username'];
            return Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 2),
                    height: size.height / 5,
                    width: double.infinity,
                    child: Card(
                      color: HexColor('F0EEEE'),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Bună, $username!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height / 5,
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          EcranAlimentatie.routeName);
                                    },
                                    child: CardHome(
                                        'Alimentație', size, Icons.restaurant)),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(EcranHidratare.routeName);
                                    },
                                    child: CardHome(
                                        'Hidratare', size, Icons.local_drink)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 5,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(EcranAntrenament.routeName);
                                  },
                                  child: CardHome('Antrenament', size,
                                      Icons.fitness_center),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(EcranRetete.routeName);
                                    },
                                    child: CardHome(
                                        'Rețete', size, Icons.menu_book)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 5,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(EcranBodyFat.routeName);
                                  },
                                  child:
                                      CardHome('Body Fat', size, Icons.percent),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(EcranSanatate.routeName);
                                  },
                                  child: CardHome('Sănătate', size,
                                      Icons.medical_information),
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
              ),
            );
          }),
    );
  }
}

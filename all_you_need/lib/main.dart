import 'package:all_you_need/lista_retete.dart';
import 'package:all_you_need/ecrane/alimentatie/ecran_alimentatie.dart';
import 'package:all_you_need/ecrane/antrenament/ecran_antrenament.dart';
import 'package:all_you_need/ecrane/ecran_bodyfat.dart';
import 'package:all_you_need/ecrane/profil/ecran_detalii_personale.dart';
import 'package:all_you_need/ecrane/ecran_hidratare.dart';
import 'package:all_you_need/ecrane/profil/ecran_masuratori.dart';
import 'package:all_you_need/ecrane/ecran_progres.dart';
import 'package:all_you_need/ecrane/ecran_home.dart';
import 'package:all_you_need/ecrane/profil/ecran_profil.dart';
import 'package:all_you_need/ecrane/retete/ecran_retete.dart';
import 'package:all_you_need/ecrane/ecran_sanatate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ecrane/autentificare/ecran_autentificare.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All You Need',
      theme: ThemeData(
        primaryColor: HexColor('#74DDBF'),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.tealAccent.shade700),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#74DDBF'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return const EcranHome();
          }
          return const EcranAutentificare();
        },
      ),
      routes: {
        EcranHome.routeName: (ctx) => const EcranHome(),
        EcranProfil.routeName: (ctx) => const EcranProfil(),
        EcranProgres.routeName: (ctx) => const EcranProgres(),
        EcranAlimentatie.routeName: (ctx) => const EcranAlimentatie(),
        EcranHidratare.routeName: (ctx) => const EcranHidratare(),
        EcranAntrenament.routeName: (ctx) => const EcranAntrenament(),
        EcranRetete.routeName: (ctx) => const EcranRetete(retete: listaRetete),
        EcranBodyFat.routeName: (ctx) => const EcranBodyFat(),
        EcranSanatate.routeName: (ctx) => const EcranSanatate(),
        EcranDetaliiPersonale.routeName: (ctx) => const EcranDetaliiPersonale(),
        EcranMasuratori.routeName: (ctx) => const EcranMasuratori(),
      },
    );
  }
}

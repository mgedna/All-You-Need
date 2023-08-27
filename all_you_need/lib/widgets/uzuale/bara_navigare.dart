import 'package:all_you_need/ecrane/ecran_progres.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../ecrane/profil/ecran_profil.dart';

class BaraNavigare extends StatelessWidget {
  const BaraNavigare({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 55,
      color: Colors.white,
      child: IconTheme(
        data: IconThemeData(color: HexColor('030303')),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(EcranProgres.routeName);
              },
              child: Column(
                children: const [
                  Icon(Icons.moving),
                  Text('Progres'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Column(
                children: const [
                  Icon(Icons.home),
                  Text('Home'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(EcranProfil.routeName);
              },
              child: Column(
                children: const [
                  Icon(Icons.person),
                  Text('Profil'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

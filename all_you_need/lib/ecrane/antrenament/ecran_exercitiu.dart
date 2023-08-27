import 'package:all_you_need/ecrane/antrenament/ecran_cronometru.dart';
import 'package:flutter/material.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';

import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:hexcolor/hexcolor.dart';

class EcranExercitiu extends StatelessWidget {
  final String nume;
  final String link;
  final List<dynamic>? exercitii;
  final String tipAntr;
  final String greutate;
  const EcranExercitiu(
      this.tipAntr, this.nume, this.link, this.greutate, this.exercitii,
      {super.key});

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
                Text(
                  nume,
                  style: const TextStyle(fontSize: 40),
                ),
                Text(
                  'Greutate: $greutate kg',
                  style: const TextStyle(fontSize: 20, color: Colors.blueGrey),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 5,
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                        backgroundColor: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.5),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '5',
                              style: TextStyle(fontSize: 60),
                            ),
                            Text(
                              'repetări',
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    var exercitiiNou = exercitii;
                    exercitiiNou!.add(nume);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => EcranCronometru(
                          tipAntr,
                          exercitiiNou,
                        ),
                      ),
                    );
                  },
                  child: const Text('Gata'),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      HexColor('F0EEEE'),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => Dialog(
                              child: Image.network(
                                link,
                                width: double.infinity,
                                height: 400,
                                fit: BoxFit.fill,
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.help_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: const Text(
                    'Cum se execută exercițiul?',
                    style: TextStyle(color: Colors.black54),
                  ),
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

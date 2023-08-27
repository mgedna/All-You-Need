import 'dart:async';
import 'package:all_you_need/ecrane/antrenament/ecran_antrenament.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class EcranCronometru extends StatefulWidget {
  final List<dynamic>? exercitii;
  final String tipAntr;
  const EcranCronometru(this.tipAntr, this.exercitii, {super.key});

  @override
  State<EcranCronometru> createState() => _EcranCronometruState();
}

class _EcranCronometruState extends State<EcranCronometru> {
  static const maxSecunde = 180;
  int secunde = maxSecunde;
  Timer? timer;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setareSursa();
    startTimer();
  }

  Future setareSursa() async {
    await audioPlayer.setSource(AssetSource('fluierat.mp3'));
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void resetTimer() => setState(() {
        secunde = maxSecunde;
      });

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (secunde > 0) {
        setState(() {
          secunde--;
        });
      } else {
        stopTimer(reset: false);
        await audioPlayer.resume();
        await audioPlayer.setReleaseMode(ReleaseMode.loop);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      timer?.cancel();
    });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: secunde / maxSecunde,
                        strokeWidth: 12,
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                        backgroundColor: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.5),
                      ),
                      Center(
                        child: secunde == 0
                            ? Icon(
                                Icons.done,
                                size: 112,
                                color: Theme.of(context).primaryColor,
                              )
                            : Text(
                                '$secunde',
                                style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                buildButtons(),
              ],
            ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    final pornit = timer == null ? false : timer!.isActive;
    final complet = secunde == maxSecunde || secunde == 0;

    return pornit || !complet
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (pornit) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
                child: Text(
                  pornit ? 'Pauza' : 'Reluare',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  stopTimer();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => EcranAntrenament(
                        exercitii: widget.exercitii,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Gata',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: () {
              stopTimer();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EcranAntrenament(
                    exercitii: widget.exercitii,
                  ),
                ),
              );
            },
            child: const Text(
              'Gata',
              style: TextStyle(fontSize: 20),
            ),
          );
  }
}

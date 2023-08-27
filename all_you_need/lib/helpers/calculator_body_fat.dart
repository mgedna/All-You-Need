import 'dart:math';

class CalculatorBodyFat {
  static double lg(int val) {
    return log(val) / log(10);
  }

  static int calculeazaBodyFat(
      String gen, int inaltime, int talie, int gat, int sold) {
    double procent;
    if (gen == 'Feminin') {
      // formula pt body fat pt femei
      procent = 495 /
              (1.29579 -
                  0.35004 * lg(talie + sold - gat) +
                  0.22100 * lg(inaltime)) -
          450;
    } else {
      //formula pt body fat pt bărbați
      procent =
          495 / (1.0324 - 0.19077 * lg(talie - gat) + 0.15456 * lg(inaltime)) -
              450;
    }
    if (procent.round() >= 0) {
      return procent.round();
    } else {
      return 0;
    }
  }

  static String interpretare(String gen, int procent) {
    String interpretare = '';
    if (gen == 'Feminin') {
      if (procent < 10) {
        interpretare = 'Mai puțin decât grăsimea esențială';
      } else if (procent >= 10 && procent <= 13) {
        interpretare = 'Grăsime esențială';
      } else if (procent >= 14 && procent <= 20) {
        interpretare = 'Sportiv';
      } else if (procent >= 21 && procent <= 24) {
        interpretare = 'Fitness';
      } else if (procent >= 25 && procent <= 31) {
        interpretare = 'Greutate medie';
      } else {
        interpretare = 'Obezitate';
      }
    } else {
      if (procent < 2) {
        interpretare = 'Mai puțin decât grăsimea esențială';
      } else if (procent >= 2 && procent <= 5) {
        interpretare = 'Grăsime esențială';
      } else if (procent >= 6 && procent <= 13) {
        interpretare = 'Sportiv';
      } else if (procent >= 14 && procent <= 17) {
        interpretare = 'Fitness';
      } else if (procent >= 18 && procent <= 24) {
        interpretare = 'Greutate medie';
      } else {
        interpretare = 'Obezitate';
      }
    }
    return interpretare;
  }
}

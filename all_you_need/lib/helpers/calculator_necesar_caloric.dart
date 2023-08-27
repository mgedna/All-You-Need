class CalculatorNecesarCaloric {
  static int calculeazaRataMetabolicaBazala(
      String gen, int greutate, int inaltime, int varsta) {
    double bmr = 0;
    if (gen == 'Feminin') {
      bmr = 655.1 + (9.563 * greutate) + (1.850 * inaltime) - (4.676 * varsta);
    } else {
      bmr = 66.47 + (13.75 * greutate) + (5.003 * inaltime) - (6.755 * varsta);
    }
    return bmr.round();
  }

  static int calculeazaNecesarCaloric(String gen, int greutate,
      int greutateObiectiv, int inaltime, int varsta, String nivelActivitate) {
    int bmr = calculeazaRataMetabolicaBazala(gen, greutate, inaltime, varsta);
    double necesarCaloric = 0.0;
    if (nivelActivitate == 'Sedentar') {
      necesarCaloric = bmr * 1.2;
    } else if (nivelActivitate == 'Activitate usoara') {
      necesarCaloric = bmr * 1.375;
    } else if (nivelActivitate == 'Activitate moderata') {
      necesarCaloric = bmr * 1.55;
    } else if (nivelActivitate == 'Activ') {
      necesarCaloric = bmr * 1.725;
    } else {
      necesarCaloric = bmr * 1.9;
    }
    if (greutateObiectiv < greutate) {
      //vrea sa scada in greutate
      return (necesarCaloric - 500).round();
    } else if (greutate == greutateObiectiv) {
      //vrea sa isi mentina greutatea
      return necesarCaloric.round();
    } else {
      //vrea sa creasca in greutate
      return (necesarCaloric + 500).round();
    }
  }

  static double proteine(int calorii) {
    return 0.2 * calorii / 4;
  }

  static double carbohidrati(int calorii) {
    return 0.5 * calorii / 4;
  }

  static double grasimi(int calorii) {
    return 0.3 * calorii / 9;
  }

  static int fibre(int calorii) {
    return (14 / 1000 * calorii).round();
  }
}

import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../widgets/uzuale/appbar_personalizat.dart';
import '../widgets/uzuale/bara_navigare.dart';

class EcranProgres extends StatefulWidget {
  static const routeName = '/progres';
  const EcranProgres({super.key});

  @override
  State<EcranProgres> createState() => _EcranProgresState();
}

class _EcranProgresState extends State<EcranProgres> {
  final CollectionReference weightsCollection =
      FirebaseFirestore.instance.collection('users');
  late Future<List<DateMasuratori>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<DateMasuratori>> fetchData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('masuratori');

    final QuerySnapshot snapshot = await collectionReference.get();

    final List<DateMasuratori> listaDateMasuratori = snapshot.docs.map((doc) {
      final data = doc['data'] as Timestamp;
      final weight = double.parse(doc['greutate']);

      return DateMasuratori(
        data: data.toDate(),
        greutate: weight,
      );
    }).toList();

    return listaDateMasuratori;
  }

  charts.TimeSeriesChart creareGrafic(List<DateMasuratori> listaGreutati) {
    final dateFinale = <DateMasuratori>[];
    double? greutateAnterioara;

    for (var i = 0; i < listaGreutati.length; i++) {
      final greutateCurenta = listaGreutati[i].greutate;
      if (greutateCurenta != greutateAnterioara) {
        dateFinale.add(listaGreutati[i]);
      }
      greutateAnterioara = greutateCurenta;
    }
    return charts.TimeSeriesChart(
      [
        charts.Series<DateMasuratori, DateTime>(
          id: 'Greutate',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (DateMasuratori dateGreutate, _) => dateGreutate.data,
          measureFn: (DateMasuratori dateGreutate, _) => dateGreutate.greutate,
          data: dateFinale,
          displayName: 'Greutate',
        )
      ],
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: charts.CircleSymbolRenderer(),
        ),
        charts.ChartTitle('Greutate',
            behaviorPosition: charts.BehaviorPosition.bottom),
        charts.SeriesLegend(),
      ],
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
        includeArea: false,
        includeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Progres'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Eroare: ${snapshot.error}'));
                  }
                  final listaGreutati = snapshot.data ?? [];
                  final grafic = creareGrafic(listaGreutati);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: charts.TimeSeriesChart(
                        grafic.seriesList,
                        animate: true,
                        dateTimeFactory: const charts.LocalDateTimeFactory(),
                      ),
                    ),
                  );
                }),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

class DateMasuratori {
  final DateTime data;
  final double greutate;

  DateMasuratori({
    required this.data,
    required this.greutate,
  });
}

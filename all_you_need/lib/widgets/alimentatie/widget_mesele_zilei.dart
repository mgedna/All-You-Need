import 'dart:convert';

import 'package:all_you_need/ecrane/alimentatie/ecran_adauga_aliment.dart';
import 'package:all_you_need/ecrane/alimentatie/ecran_detalii_aliment.dart';
import 'package:all_you_need/modele/aliment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WidgetMeseleZilei extends StatefulWidget {
  final String numeMasa;
  final String _caloriiConsumate;
  final List<dynamic> listaAlimente;
  const WidgetMeseleZilei(
    this.numeMasa,
    this._caloriiConsumate,
    this.listaAlimente, {
    super.key,
  });

  @override
  State<WidgetMeseleZilei> createState() => _WidgetMeseleZileiState();
}

class _WidgetMeseleZileiState extends State<WidgetMeseleZilei> {
  void selecteazaAliment(
      BuildContext context, Aliment aliment, dynamic nrPortii) {
    if (widget.numeMasa == 'Micul dejun') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(
            aliment,
            'micDejun',
            nrPortii: nrPortii.toString(),
            metoda: 'Actualizeaza',
          ),
        ),
      );
    } else if (widget.numeMasa == 'Pranz') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(
            aliment,
            'pranz',
            nrPortii: nrPortii.toString(),
            metoda: 'Actualizeaza',
          ),
        ),
      );
    } else if (widget.numeMasa == 'Cina') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(
            aliment,
            'cina',
            nrPortii: nrPortii.toString(),
            metoda: 'Actualizeaza',
          ),
        ),
      );
    }
  }

  Future<void> getAliment(dynamic a) async {
    var url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/${a['id']}.json');

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 1) {
          dynamic alimentRezultat = data;
          if (alimentRezultat != null) {
            double calorii = 0.0;
            if (alimentRezultat['product']['nutriments']['energy-kcal_100g']
                is int) {
              calorii = (alimentRezultat['product']['nutriments']
                          ['energy-kcal_100g'] ??
                      0)
                  .toDouble();
            } else if (alimentRezultat['product']['nutriments']
                ['energy-kcal_100g'] is String) {
              calorii = double.parse(alimentRezultat['product']['nutriments']
                      ['energy-kcal_100g'] ??
                  '0');
            } else if (alimentRezultat['product']['nutriments']
                ['energy-kcal_100g'] is double) {
              calorii =
                  alimentRezultat['product']['nutriments']['energy-kcal_100g'];
            }
            double proteine = 0.0;
            if (alimentRezultat['product']['nutriments']['proteins_100g']
                is int) {
              proteine = (alimentRezultat['product']['nutriments']
                          ['proteins_100g'] ??
                      0)
                  .toDouble();
            } else if (alimentRezultat['product']['nutriments']['proteins_100g']
                is String) {
              proteine = double.parse(alimentRezultat['product']['nutriments']
                      ['proteins_100g'] ??
                  '0');
            } else if (alimentRezultat['product']['nutriments']['proteins_100g']
                is double) {
              proteine =
                  alimentRezultat['product']['nutriments']['proteins_100g'];
            }
            double carbs = 0.0;
            if (alimentRezultat['product']['nutriments']['carbohydrates_100g']
                is int) {
              carbs = (alimentRezultat['product']['nutriments']
                          ['carbohydrates_100g'] ??
                      0)
                  .toDouble();
            } else if (alimentRezultat['product']['nutriments']
                ['carbohydrates_100g'] is String) {
              carbs = double.parse(alimentRezultat['product']['nutriments']
                      ['carbohydrates_100g'] ??
                  '0');
            } else if (alimentRezultat['product']['nutriments']
                ['carbohydrates_100g'] is double) {
              carbs = alimentRezultat['product']['nutriments']
                  ['carbohydrates_100g'];
            }
            double grasimi = 0.0;
            if (alimentRezultat['product']['nutriments']['fat_100g'] is int) {
              grasimi =
                  (alimentRezultat['product']['nutriments']['fat_100g'] ?? 0)
                      .toDouble();
            } else if (alimentRezultat['product']['nutriments']['fat_100g']
                is String) {
              grasimi = double.parse(
                  alimentRezultat['product']['nutriments']['fat_100g'] ?? '0');
            } else if (alimentRezultat['product']['nutriments']['fat_100g']
                is double) {
              grasimi = alimentRezultat['product']['nutriments']['fat_100g'];
            }
            double fibre = 0.0;
            if (alimentRezultat['product']['nutriments']['fiber_100g'] is int) {
              fibre =
                  (alimentRezultat['product']['nutriments']['fiber_100g'] ?? 0)
                      .toDouble();
            } else if (alimentRezultat['product']['nutriments']['fiber_100g']
                is String) {
              fibre = double.parse(alimentRezultat['product']['nutriments']
                      ['fiber_100g'] ??
                  '0');
            } else if (alimentRezultat['product']['nutriments']['fiber_100g']
                is double) {
              fibre = alimentRezultat['product']['nutriments']['fiber_100g'];
            }
            var nrPortii = a['calorii'] / calorii;
            // proteine = proteine * nrPortii;
            // carbs = carbs * nrPortii;
            // grasimi * grasimi * nrPortii;
            // fibre = fibre * nrPortii;

            var aliment = Aliment(
              id: a['id'],
              nume: a['nume'],
              brand: alimentRezultat['product']['brands'] ?? '',
              imageUrl: alimentRezultat['product']['image_url'] ?? '',
              calorii: calorii,
              proteine: proteine,
              carbs: carbs,
              grasimi: grasimi,
              fibre: fibre,
            );
            if (aliment.id != '' &&
                aliment.nume != '' &&
                aliment.brand != '' &&
                aliment.imageUrl != '' &&
                aliment.calorii != 0.0 &&
                aliment.proteine != 0.0 &&
                aliment.carbs != 0.0 &&
                aliment.grasimi != 0.0 &&
                aliment.fibre != 0.0) {
              selecteazaAliment(context, aliment, nrPortii);
            }
          }
        } else {
          // print('Error: ${data['status_verbose']}');
        }
      } else {
        // print('Error: ${response.reasonPhrase}');
      }
    }).catchError((error) {
      // print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.numeMasa,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white),
                ),
                Text(
                  widget._caloriiConsumate,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.listaAlimente.length,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  getAliment(widget.listaAlimente[index]);
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 2,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                              widget.listaAlimente.elementAt(index)['nume'])),
                      Text(
                          '${widget.listaAlimente.elementAt(index)['calorii']} kcal'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EcranAdaugaAliment(widget.numeMasa),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Adauga aliment',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

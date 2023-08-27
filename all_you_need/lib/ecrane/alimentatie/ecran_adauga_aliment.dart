import 'dart:convert';

import 'package:all_you_need/ecrane/alimentatie/ecran_detalii_aliment.dart';
import 'package:all_you_need/modele/aliment.dart';
import 'package:all_you_need/widgets/alimentatie/card_aliment.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class EcranAdaugaAliment extends StatefulWidget {
  static const routeName = '/adaugaAliment';
  final String numeMasa;

  const EcranAdaugaAliment(this.numeMasa, {super.key});

  @override
  State<EcranAdaugaAliment> createState() => _EcranAdaugaAlimentState();
}

class _EcranAdaugaAlimentState extends State<EcranAdaugaAliment> {
  String _alimentCautat = '';
  String codDeBare = '';
  dynamic alimentRezultat;
  List<Aliment> listaAlimente = [];
  bool seIncarca = false;

  void _cautaAliment(String text) async {
    setState(() {
      listaAlimente = [];
      seIncarca = true;
    });
    var url = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?action=process&search_terms=$text&json=true');
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        var products = data['products'];
        for (var product in products) {
          double calorii = 0.0;
          if (product['nutriments']['energy-kcal_100g'] is int) {
            calorii =
                (product['nutriments']['energy-kcal_100g'] ?? 0).toDouble();
          } else if (product['nutriments']['energy-kcal_100g'] is String) {
            calorii =
                double.parse(product['nutriments']['energy-kcal_100g'] ?? '0');
          } else if (product['nutriments']['energy-kcal_100g'] is double) {
            calorii = product['nutriments']['energy-kcal_100g'];
          }
          double proteine = 0.0;
          if (product['nutriments']['proteins_100g'] is int) {
            proteine = (product['nutriments']['proteins_100g'] ?? 0).toDouble();
          } else if (product['nutriments']['proteins_100g'] is String) {
            proteine =
                double.parse(product['nutriments']['proteins_100g'] ?? '0');
          } else if (product['nutriments']['proteins_100g'] is double) {
            proteine = product['nutriments']['proteins_100g'];
          }
          double carbs = 0.0;
          if (product['nutriments']['carbohydrates_100g'] is int) {
            carbs =
                (product['nutriments']['carbohydrates_100g'] ?? 0).toDouble();
          } else if (product['nutriments']['carbohydrates_100g'] is String) {
            carbs = double.parse(
                product['nutriments']['carbohydrates_100g'] ?? '0');
          } else if (product['nutriments']['carbohydrates_100g'] is double) {
            carbs = product['nutriments']['carbohydrates_100g'];
          }
          double grasimi = 0.0;
          if (product['nutriments']['fat_100g'] is int) {
            grasimi = (product['nutriments']['fat_100g'] ?? 0).toDouble();
          } else if (product['nutriments']['fat_100g'] is String) {
            grasimi = double.parse(product['nutriments']['fat_100g'] ?? '0');
          } else if (product['nutriments']['fat_100g'] is double) {
            grasimi = product['nutriments']['fat_100g'];
          }
          double fibre = 0.0;
          if (product['nutriments']['fiber_100g'] is int) {
            fibre = (product['nutriments']['fiber_100g'] ?? 0).toDouble();
          } else if (product['nutriments']['fiber_100g'] is String) {
            fibre = double.parse(product['nutriments']['fiber_100g'] ?? '0');
          } else if (product['nutriments']['fiber_100g'] is double) {
            fibre = product['nutriments']['fiber_100g'];
          }
          var aliment = Aliment(
            id: product['_id'].toString(),
            nume: product['product_name'] ?? '',
            brand: product['brands'] ?? '',
            imageUrl: product['image_url'] ?? '',
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
            setState(() {
              listaAlimente.add(aliment);
            });
          }
        }
      }
    });
    setState(() {
      seIncarca = false;
    });
  }

  Future<void> scanBarcode() async {
    String rezultat = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Culoare indicator
      'Anulează',
      true, // Afisare icon lanterna
      ScanMode.BARCODE, // tipul scanarii
    );
    if (rezultat == '-1') {
      return;
    }

    setState(() {
      codDeBare = rezultat;
    });

    var url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$codDeBare.json');

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 1) {
          setState(() {
            alimentRezultat = data;
          });
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
            var aliment = Aliment(
              id: alimentRezultat['product']['_id'].toString(),
              nume: alimentRezultat['product']['product_name'] ?? '',
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
              selecteazaAliment(context, aliment);
            } else {
              setState(() {
                alimentRezultat = null;
              });
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

  void selecteazaAliment(BuildContext context, Aliment aliment) {
    if (widget.numeMasa == 'Micul dejun') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(aliment, 'micDejun'),
        ),
      );
    } else if (widget.numeMasa == 'Pranz') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(aliment, 'pranz'),
        ),
      );
    } else if (widget.numeMasa == 'Cina') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EcranDetaliiAliment(aliment, 'cina'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPers(widget.numeMasa),
      drawer: const Meniu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              //bara de cautare reteta
              decoration: InputDecoration(
                hintText: 'Cauta aliment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _cautaAliment(_alimentCautat);
                  },
                ),
              ),
              onSubmitted: (value) {
                _cautaAliment(_alimentCautat);
              },
              onChanged: (value) {
                setState(() {
                  _alimentCautat = value;
                });
                _cautaAliment(_alimentCautat);
              },
            ),
          ),
          GestureDetector(
            onTap: scanBarcode,
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(CupertinoIcons.barcode, size: 33),
                  Text(
                    'Scaneaza cod de bare',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 20,
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _alimentCautat == ''
                ? codDeBare == ''
                    ? const Text('')
                    : alimentRezultat == null
                        ? Text(
                            'Nu exista niciun aliment corespunzator codului de bare $codDeBare')
                        : Column(
                            children: [
                              Text(codDeBare),
                              Text(
                                  'Nume aliment: ${alimentRezultat['product']['product_name']}'),
                              Text(
                                  'Calorii per 100g: ${alimentRezultat['product']['nutriments']['energy-kcal']}'),
                            ],
                          )
                : seIncarca
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: listaAlimente.isEmpty
                            ? const Text('Nu exista niciun rezultat')
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Rezultatele cautarii',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: listaAlimente.length,
                                      itemBuilder: (ctx, index) => CardAliment(
                                        aliment: listaAlimente[index],
                                        alimentSelectat: (aliment) {
                                          selecteazaAliment(context, aliment);
                                        },
                                      ),
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
  }
}

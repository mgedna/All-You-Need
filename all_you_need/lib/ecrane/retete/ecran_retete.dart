import 'package:all_you_need/ecrane/retete/ecran_detalii_reteta.dart';
import 'package:all_you_need/modele/reteta.dart';
import 'package:all_you_need/widgets/retete/card_reteta.dart';
import 'package:flutter/material.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';

class EcranRetete extends StatefulWidget {
  static const routeName = '/retete';
  final List<Reteta> retete;
  const EcranRetete({
    super.key,
    required this.retete,
  });

  @override
  State<EcranRetete> createState() => _EcranReteteState();
}

class _EcranReteteState extends State<EcranRetete> {
  String _retetaCautata = '';
  late List<Reteta> _reteteIntoarse;

  void _cautaReteta(String text) {
    if (_retetaCautata.trim() == '') {
      setState(() {
        _reteteIntoarse = widget.retete;
      });
    } else {
      setState(() {
        _reteteIntoarse = List.empty(growable: true);
        for (var i in widget.retete) {
          if (i.title
              .toLowerCase()
              .contains(_retetaCautata.trimLeft().trimRight().toLowerCase())) {
            _reteteIntoarse.add(i);
          }
        }
      });
    }
  }

  void selecteazaReteta(BuildContext context, Reteta reteta) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EcranDetaliiReteta(reteta: reteta),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _reteteIntoarse = widget.retete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Retete'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              //bara de cautare reteta
              decoration: InputDecoration(
                hintText: 'Cauta reteta...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _cautaReteta(_retetaCautata);
                  },
                ),
              ),
              onSubmitted: (value) {
                _cautaReteta(_retetaCautata);
              },
              onChanged: (value) {
                setState(() {
                  _retetaCautata = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reteteIntoarse.length,
              itemBuilder: (ctx, index) => CardReteta(
                reteta: _reteteIntoarse[index],
                retetaSelectata: (reteta) {
                  selecteazaReteta(context, reteta);
                },
              ),
            ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

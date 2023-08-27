import 'package:all_you_need/modele/aliment.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transparent_image/transparent_image.dart';

class CardAliment extends StatelessWidget {
  final Aliment aliment;
  const CardAliment({
    super.key,
    required this.aliment,
    required this.alimentSelectat,
  });
  final void Function(Aliment aliment) alimentSelectat;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HexColor('F0EEEE'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          ClipRRect(
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(aliment.imageUrl),
              width: 100,
              height: 100,
              fit: BoxFit.cover, //pt a nu avea imagine distorsionata
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aliment.nume,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('${aliment.calorii} kcal, ${aliment.brand}, 100g'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              alimentSelectat(aliment);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

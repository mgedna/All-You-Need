import 'package:all_you_need/modele/reteta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:transparent_image/transparent_image.dart';

class CardReteta extends StatelessWidget {
  final Reteta reteta;
  const CardReteta({
    super.key,
    required this.reteta,
    required this.retetaSelectata,
  });
  final void Function(Reteta reteta) retetaSelectata;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HexColor('F0EEEE'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          retetaSelectata(reteta);
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
              height: 140,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(reteta.imageUrl),
                width: 127,
                height: 123,
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
                    reteta.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      Text('${reteta.duration} min'),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.flame_fill),
                      Text('${reteta.calories} kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CardHome extends StatelessWidget {
  final String text;
  final Size size;
  final IconData pictograma;
  const CardHome(this.text, this.size, this.pictograma, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: size.width / 2,
      child: IconTheme(
        data: IconThemeData(color: HexColor('1E90FF')),
        child: Card(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(pictograma, size: 40),
              Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

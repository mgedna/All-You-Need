import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Meniu extends StatelessWidget {
  const Meniu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('All You Need'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).popUntil((route) => route
                .isFirst); //pop pana cand ajungem la primul element din stiva
            FirebaseAuth.instance.signOut();
          },
        ),
      ]),
    );
  }
}

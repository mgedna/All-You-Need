import 'package:all_you_need/ecrane/profil/ecran_profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppBarPers extends StatelessWidget implements PreferredSizeWidget {
  final String titlu;
  const AppBarPers(this.titlu, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titlu),
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Icon(Icons.menu, color: HexColor('030303')),
      ),
      actions: [
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              if (userData == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(EcranProfil.routeName);
                },
                child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(userData['pozaProfil'])),
              );
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/autentificare/auth_form.dart';

class EcranAutentificare extends StatefulWidget {
  const EcranAutentificare({super.key});

  @override
  State<EcranAutentificare> createState() => _EcranAutentificareState();
}

class _EcranAutentificareState extends State<EcranAutentificare> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _trimitereFormularAutentificare(String email, String password,
      String username, File? imagine, bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('poze_profil')
            .child('${userCredential.user!.uid}.jpg');
        UploadTask uploadTask = ref.putFile(imagine!);
        await Future.value(uploadTask);
        String url = "";
        await ref.getDownloadURL().then((value) => url = value);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
          'necesarCaloric': -1,
          'bodyFat': -1,
          'gen': '-',
          'pozaProfil': url,
        });
      }
    } catch (err) {
      var message = err.toString();
      var mesajEroare =
          'A fost o eroare, va rugam sa va verificati credentialele!';
      if (message ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        mesajEroare = 'Adresa de email este asociata unui alt cont.';
      } else if (message ==
          '[firebase_auth/invalid-email] The email address is badly formatted.') {
        mesajEroare = 'Adresa de email are un format invalid.';
      } else if (message ==
          '[firebase_auth/weak-password] Password should be at least 6 characters.') {
        mesajEroare = 'Parola trebuie sa aiba cel putin 6 caractere.';
      } else if (message ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
        mesajEroare = 'Parola este incorecta.';
      } else if (message ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        mesajEroare = 'Nu exista niciun utilizator cu aceasta adresa de email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mesajEroare),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetareParola(String email, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (ctx.mounted) {
        showDialog(
            context: ctx,
            builder: (ctx) {
              return AlertDialog(
                content:
                    const Text('Link-ul de resetare al parolei a fost trimis.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //pt AlertDialog
                      Navigator.of(context).pop(); //pt Pagina de resetare
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      var mesajEroare = e.message.toString();
      if (e.code == 'user-not-found') {
        mesajEroare = 'Nu exista niciun utilizator cu aceasta adresa de email.';
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(mesajEroare),
            );
          });
    }
  }

  void _signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return;
    } else {
      docRef.set({
        'username': userCredential.additionalUserInfo!.profile!["name"],
        'email': userCredential.additionalUserInfo!.profile!["email"],
        'necesarCaloric': -1,
        'bodyFat': -1,
        'gen': '-',
        'pozaProfil': userCredential.additionalUserInfo!.profile!["picture"],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _trimitereFormularAutentificare,
        _isLoading,
        _resetareParola,
        _signInWithGoogle,
      ),
    );
  }
}

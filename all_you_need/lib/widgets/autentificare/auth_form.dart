import 'dart:io';

import 'package:all_you_need/widgets/pickers/selectare_imagine.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:all_you_need/ecrane/autentificare/ecran_resetare_parola.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File? imagine,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final void Function(
    String email,
    BuildContext ctx,
  ) resetareParola;
  final void Function() signInWithGoogle;
  const AuthForm(
      this.submitFn, this.isLoading, this.resetareParola, this.signInWithGoogle,
      {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _pozaUser;

  void _imagineSelectata(File imagine) {
    _pozaUser = imagine;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pozaUser == null && !_isLogin) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Alegeti o imagine de profil.'),
            );
          });
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _pozaUser,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: HexColor('F0EEEE'),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    SelectareImagine(
                        _imagineSelectata, null, 'Alege o imagine'),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value != null &&
                          (value.isEmpty || !value.contains('@'))) {
                        return 'Introduceti o adresa de email valida!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresa de email',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value != null &&
                            (value.isEmpty || value.length < 4)) {
                          return 'Numele de utilizator trebuie sa aiba cel putin 4 caractere!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nume de utilizator',
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('parola'),
                    validator: (value) {
                      if (value != null &&
                          (value.isEmpty || value.length < 6)) {
                        return 'Parola trebuie sa aiba cel putin 6 caractere!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Parola',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  if (_isLogin)
                    const SizedBox(
                      height: 12,
                    ),
                  if (_isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EcranResetareParola(
                                      widget.resetareParola);
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Ti-ai uitat parola?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Inregistrare'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                          _isLogin ? 'Creează un cont nou' : 'Am deja un cont'),
                    ),
                  GestureDetector(
                    onTap: () => widget.signInWithGoogle(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor('F4F4F4')),
                        borderRadius: BorderRadius.circular(16),
                        color: HexColor('F0EEEE'),
                      ),
                      child: Image.asset(
                        'lib/imagini/google.png',
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

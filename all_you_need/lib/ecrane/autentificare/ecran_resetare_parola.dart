import 'package:flutter/material.dart';

class EcranResetareParola extends StatefulWidget {
  final void Function(
    String email,
    BuildContext ctx,
  ) submitFn;
  const EcranResetareParola(this.submitFn, {super.key});

  @override
  State<EcranResetareParola> createState() => _EcranResetareParolaState();
}

class _EcranResetareParolaState extends State<EcranResetareParola> {
  final _recParolaKey = GlobalKey<FormState>();
  var _userEmail = '';

  void _trySubmit() {
    final isValid = _recParolaKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _recParolaKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperare parola'),
      ),
      body: Form(
        key: _recParolaKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Introduceti adresa de email pentru a primi link-ul de resetare al parolei.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              key: const ValueKey('email'),
              validator: (value) {
                if (value != null && (value.isEmpty || !value.contains('@'))) {
                  return 'Introduceti o adresa de email valida!';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Adresa de email',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSaved: (value) {
                _userEmail = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: _trySubmit,
              child: const Text('Resetare parola'),
            ),
          ],
        ),
      ),
    );
  }
}

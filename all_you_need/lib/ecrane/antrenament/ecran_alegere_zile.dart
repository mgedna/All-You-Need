import 'package:all_you_need/ecrane/antrenament/ecran_antrenament.dart';
import 'package:all_you_need/widgets/uzuale/appbar_personalizat.dart';
import 'package:all_you_need/widgets/uzuale/bara_navigare.dart';
import 'package:all_you_need/widgets/uzuale/meniu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class EcranAlegereZile extends StatefulWidget {
  const EcranAlegereZile({super.key});

  @override
  State<EcranAlegereZile> createState() => _EcranAlegereZileState();
}

class _EcranAlegereZileState extends State<EcranAlegereZile> {
  final _culoareButon = [HexColor('#74DDBF'), HexColor('#BDF8E6')];
  var _apasatLuni = false;
  var _apasatMarti = false;
  var _apasatMiercuri = false;
  var _apasatJoi = false;
  var _apasatVineri = false;
  var _apasatSambata = false;
  var _apasatDuminica = false;
  var _nrZile = 0;

  void salveaza() async {
    var navigator = Navigator.of(context);
    var zileActive = [];
    if (_apasatLuni) {
      zileActive.add('lun.');
    }
    if (_apasatMarti) {
      zileActive.add('mar.');
    }
    if (_apasatMiercuri) {
      zileActive.add('mie.');
    }
    if (_apasatJoi) {
      zileActive.add('joi');
    }
    if (_apasatVineri) {
      zileActive.add('vin.');
    }
    if (_apasatSambata) {
      zileActive.add('sâm.');
    }
    if (_apasatDuminica) {
      zileActive.add('dum.');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'zileAntrenament': zileActive,
    });
    navigator.pop();
    navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const EcranAntrenament()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPers('Alegere zile antrenament'),
      drawer: const Meniu(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'În ce zile doriți să vă antrenați?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatLuni == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatLuni = !_apasatLuni;
                            if (_apasatLuni) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatLuni = !_apasatLuni;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatDuminica || _apasatMarti) {
                            setState(() {
                              _apasatLuni = !_apasatLuni;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('L'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatMarti == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatMarti = !_apasatMarti;
                            if (_apasatMarti) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatMarti = !_apasatMarti;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatLuni || _apasatMiercuri) {
                            setState(() {
                              _apasatMarti = !_apasatMarti;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('M'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatMiercuri == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatMiercuri = !_apasatMiercuri;
                            if (_apasatMiercuri) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatMiercuri = !_apasatMiercuri;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatMarti || _apasatJoi) {
                            setState(() {
                              _apasatMiercuri = !_apasatMiercuri;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('Mi'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatJoi == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatJoi = !_apasatJoi;
                            if (_apasatJoi) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatJoi = !_apasatJoi;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatMiercuri || _apasatVineri) {
                            setState(() {
                              _apasatJoi = !_apasatJoi;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('J'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatVineri == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatVineri = !_apasatVineri;
                            if (_apasatVineri) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatVineri = !_apasatVineri;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatJoi || _apasatSambata) {
                            setState(() {
                              _apasatVineri = !_apasatVineri;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('V'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatSambata == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatSambata = !_apasatSambata;
                            if (_apasatSambata) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatSambata = !_apasatSambata;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatVineri || _apasatDuminica) {
                            setState(() {
                              _apasatSambata = !_apasatSambata;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('S'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _apasatDuminica == false
                                ? _culoareButon.first
                                : _culoareButon.last),
                        onPressed: () {
                          setState(() {
                            _apasatDuminica = !_apasatDuminica;
                            if (_apasatDuminica) {
                              _nrZile++;
                            } else {
                              _nrZile--;
                            }
                          });
                          if (_nrZile > 3) {
                            setState(() {
                              _apasatDuminica = !_apasatDuminica;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Trebuie să alegeți doar 3 zile!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          } else if (_apasatSambata || _apasatLuni) {
                            setState(() {
                              _apasatDuminica = !_apasatDuminica;
                              _nrZile--;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Nu puteti alege 2 zile consecutive!'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //pt AlertDialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('D'),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: salveaza, child: const Text('Salveaza')),
              ],
            ),
          ),
          const BaraNavigare(),
        ],
      ),
    );
  }
}

import 'package:all_you_need/modele/reteta.dart';

const listaRetete = [
  Reteta(
    id: 'm1',
    title: 'Pancake cu banane',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2Fpancake.png?alt=media&token=fea0091e-96fa-4830-b90a-8a2ae91861c4',
    duration: 12,
    ingredients: [
      '1 banană',
      '2 ouă',
      '3g ulei de cocos (opțional)',
    ],
    steps: [
      'Pisăm banana cu ajutorul unei furculițe și o aducem sub forma unui piure.',
      'Adăugam ouăle și amestecăm.',
      'După ce ungem tigaia cu ulei, punem câte o lingură din compoziție.',
      'Când apar bule, întoarcem clătita pentru a se coace și pe cealaltă parte.',
    ],
    calories: 303,
  ),
  Reteta(
    id: 'm2',
    title: 'Omletă cu ciuperci',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FomletaCiuperci.png?alt=media&token=0b6e6fc7-72de-44ff-bd6d-28aa84219132',
    duration: 13,
    ingredients: [
      '60g brânză',
      '2 ouă',
      '1 castron ciuperci',
      '1 vârf de linguriță piper',
      '4.5g ulei de măsline'
    ],
    steps: [
      'Pregătim ciupercile și le tăiem.',
      'Încingem tigaia, adăugam uleiul de măsline și ciupercile și le gătim câteva minute.',
      'Batem ouăle și le adăugam în tigaie.'
          'Când partea de jos e gata, adăugăm brânza și acoperim cu un capac pentru a se coace și partea de sus.',
      'Adăugam condimentele pe deasupra și servim.',
    ],
    calories: 304,
  ),
  Reteta(
    id: 'm3',
    title: 'Terci de ovăz cu banane',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FterciBanane.png?alt=media&token=eac62bb9-6e26-42e1-af22-8d5225cfa4ac',
    duration: 7,
    ingredients: [
      '35g fulgi de ovăz',
      '1 banană',
      'scorțișoară',
      '5g miere',
    ],
    steps: [
      'Punem ovăzul într-un castron și adăugăm apă caldă cât să îl acopere.',
      'Așteptăm 5 minute pentru a se înmuia ovăzul.',
      'Adăugăm scorțișoara și mierea și amestecăm.',
      'Servim după ce adăugăm și bananele tăiate.',
    ],
    calories: 304,
  ),
  Reteta(
    id: 'm4',
    title: 'Pizza dietetică',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FpizzaDietetica.png?alt=media&token=c871d7e8-6e42-47d7-8a6b-de2804174a85',
    duration: 7,
    ingredients: [
      '1 lipie',
      '70g piept de pui fiert',
      '30g cașcaval răzuit',
      '1 lingură sos de roșii sau bulion',
      'condimentele dorite',
    ],
    steps: [
      'Adăugăm lipia în tigaie.',
      'Punem pe rând bulionul, carnea și cașcavalul.',
      'Adăugăm condimentele dorite.',
      'Acoperim cu un capac și așteptăm să se coacă.',
    ],
    calories: 425,
  ),
  Reteta(
    id: 'm5',
    title: 'Salată de linte',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FsalataLinte.png?alt=media&token=6c42a122-23e4-4bab-8606-d60fc7da65a4',
    duration: 25,
    ingredients: [
      '220g linte verde',
      'apă',
      'sare',
      '1 roșie',
      '1 castravete',
      '1 ardei',
      '3 linguri ulei de măsline',
      'jumătate de lămâie',
      'puțină mentă',
    ],
    steps: [
      'Lăsăm lintea la înmuiat cu o seară înainte.',
      'După ce scurgem lintea de apă, o adăugăm într-o oală alături de apă fiartă care trece cu un deget de linte și un praf de sare și lăsăm la fiert.',
      'Când ajunge la consistența dorită, scurgem lintea.',
      'Tocăm roșia, castravetele și ardeiul și le punem într-un castron.',
      'Punem și lintea și menta deasupra și apoi adăugăm sucul de la lamâie și uleiul și amestecăm.'
    ],
    calories: 277,
  ),
  Reteta(
    id: 'm6',
    title: 'Tocană de pui cu roșii',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FtocanaPui.png?alt=media&token=e8b2428f-0c82-4321-af2d-297cf768db47',
    duration: 25,
    ingredients: [
      '200g piept de pui',
      '1 roșie',
      '1 lingură ulei de măsline',
    ],
    steps: [
      'Tocăm carnea și roșia.',
      'Încingem tigaia și adăugăm uleiul de măsline.',
      'Adăugăm roșia în tigaie și așteptăm până prinde o culoare rozalie.',
      'Adăugăm și carnea și lăsăm să se facă amestecând continuu.',
    ],
    calories: 380,
  ),
  Reteta(
    id: 'm7',
    title: 'Cartofi cu piept de pui la cuptor',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2FcartofiCuptor.png?alt=media&token=09cc7f1f-5585-4a16-8ab6-069d38997f13',
    duration: 35,
    ingredients: [
      '1kg piept de pui',
      '2 cartofi de mărime medie',
      '3 linguri ulei de măsline',
      'sare și condimentele dorite',
    ],
    steps: [
      'Porționăm carnea și o adăugăm într-un castron, apoi punem uleiul, sarea și condimentele și amestecăm bine.',
      'Tăiem cartofii și îi amestecăm cu ulei.',
      'Într-o tavă tapetată cu hârtie de copt așezăm cartofii și carnea. Puteți adăuga condimente peste cartofi.',
      'În cuptorul preîncălzit la 200 de grade, coacem cam 25 de minute.'
    ],
    calories: 377,
  ),
  Reteta(
    id: 'm8',
    title: 'Chiftele de pui',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2Fchiftele.png?alt=media&token=5de4a338-bdf6-41f4-ade1-fa4a2262df96',
    duration: 25,
    ingredients: [
      '200g carne de pui tocată',
      '2 ouă',
      '1 ceapă mică',
      '2 legături pătrunjel',
      'sare și condimentele dorite',
    ],
    steps: [
      'Adăugăm un ou deasupra cărnii și, după ce tocăm celelalte ingrediente, le punem și pe ele și amestecăm.',
      'Încingem tigaia.',
      'Separat, batem oul rămas.',
      'Aducem sub formă de chifteluțe amestecul, îl trecem prin ou și îl punem în tigaie.',
      'După ce le coacem pe ambele părți, chiftelele sunt gata.',
    ],
    calories: 213,
  ),
  Reteta(
    id: 'm9',
    title: 'Humus',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2Fhumus.png?alt=media&token=793747f9-d36f-4362-8eb9-be856df4a426',
    duration: 45,
    ingredients: [
      '200g năut fiert',
      '1 linguriță ulei de măsline',
      '1 lingură tahini',
      '1 lămâie',
      'sare și condimentele dorite',
    ],
    steps: [
      'Fierbem năutul sau folosim unul din conservă.',
      'Aducem năutul sub formă de piure cu ajutorul unei furculițe sau al unui blender.',
      'Adăugăm restul ingredientelor și amestecăm.',
      'La sfârșit, aduăugam pe deasupra ulei de măsline și condimente.',
    ],
    calories: 260,
  ),
  Reteta(
    id: 'm10',
    title: 'Prăjitură cu fructe',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/all-you-need-ae44e.appspot.com/o/poze_retete%2Fprajitura.png?alt=media&token=fcf470cc-8620-4c25-8d6e-5d5976cdcb73',
    duration: 20,
    ingredients: [
      '3 banane',
      '4 ouă',
      '5g ulei',
      '10 bucăți fructe congelate',
    ],
    steps: [
      'Aducem bananele sub formă de piure.',
      'Adăugăm ouăle și amestecăm',
      'Punem puțin ulei în tava de copt și îl întindem cu ajutorul unui șervețel.',
      'Adăugăm fructele congelate în tavă și apoi punem și compoziția formată.',
      'Coacem 12 minute în cuptorul preîncălzit la 200 de grade.',
    ],
    calories: 130,
  ),
];

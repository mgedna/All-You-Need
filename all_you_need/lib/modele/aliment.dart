class Aliment {
  const Aliment({
    required this.id,
    required this.nume,
    required this.brand,
    required this.imageUrl,
    required this.calorii,
    required this.proteine,
    required this.carbs,
    required this.grasimi,
    required this.fibre,
  });

  final String id;
  final String nume;
  final String brand;
  final String imageUrl;
  final double calorii;
  final double proteine;
  final double carbs;
  final double grasimi;
  final double fibre;
}

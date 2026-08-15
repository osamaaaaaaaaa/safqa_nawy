class Project {
  const Project({
    required this.id,
    required this.name,
    required this.developer,
    required this.location,
    required this.startingPrice,
    required this.downPayment,
    required this.installmentYears,
    required this.delivery,
    required this.commission,
    required this.badge,
  });

  final String id;
  final String name;
  final String developer;
  final String location;
  final String startingPrice;
  final String downPayment;
  final String installmentYears;
  final String delivery;
  final String commission;
  final String badge;
}

class ProjectModel {
  final String name;
  final String developer;
  final String logo;
  final String volume;
  final List<UnitModel> units;

  const ProjectModel({
    required this.name,
    required this.developer,
    required this.logo,
    required this.volume,
    required this.units,
  });

  double get maxCommissionRate {
    if (units.isEmpty) return 0.0;
    return units.map((u) => u.commissionRate).reduce((a, b) => a > b ? a : b);
  }
}

class UnitModel {
  final String code;
  final String type;
  final String price;
  final double priceValue;
  final double commissionRate;
  final String commissionText;

  const UnitModel({
    required this.code,
    required this.type,
    required this.price,
    required this.priceValue,
    required this.commissionRate,
    required this.commissionText,
  });
}

class ProjectsRepository {
  const ProjectsRepository();

  List<ProjectModel> allProjects() {
    return const [
      ProjectModel(
        name: 'New Capital Heights',
        developer: 'Al Ahly Sabbour',
        logo: 'Heights',
        volume: 'High Demand',
        units: [
          UnitModel(
            code: 'C-09',
            type: 'Apartment',
            price: 'EGP 12.0M',
            priceValue: 12000000,
            commissionRate: 4.0,
            commissionText: 'EGP 480K',
          ),
          UnitModel(
            code: 'C-12',
            type: 'Penthouse',
            price: 'EGP 15.5M',
            priceValue: 15500000,
            commissionRate: 4.0,
            commissionText: 'EGP 620K',
          ),
        ],
      ),
      ProjectModel(
        name: 'The Valley Landmark',
        developer: 'Mountain View',
        logo: 'Valley',
        volume: 'Recommended',
        units: [
          UnitModel(
            code: 'V-102',
            type: 'Villa',
            price: 'EGP 7.2M',
            priceValue: 7200000,
            commissionRate: 3.5,
            commissionText: 'EGP 252K',
          ),
          UnitModel(
            code: 'V-105',
            type: 'Townhouse',
            price: 'EGP 8.8M',
            priceValue: 8800000,
            commissionRate: 3.5,
            commissionText: 'EGP 308K',
          ),
        ],
      ),
      ProjectModel(
        name: 'West Park',
        developer: 'SODIC',
        logo: 'West',
        volume: 'Trending',
        units: [
          UnitModel(
            code: 'T-22',
            type: 'Townhouse',
            price: 'EGP 9.4M',
            priceValue: 9400000,
            commissionRate: 3.0,
            commissionText: 'EGP 282K',
          ),
          UnitModel(
            code: 'T-25',
            type: 'Apartment',
            price: 'EGP 5.2M',
            priceValue: 5200000,
            commissionRate: 3.0,
            commissionText: 'EGP 156K',
          ),
        ],
      ),
      ProjectModel(
        name: 'East Residence',
        developer: 'Palm Hills',
        logo: 'East',
        volume: 'Steady',
        units: [
          UnitModel(
            code: 'A-1407',
            type: 'Apartment',
            price: 'EGP 5.8M',
            priceValue: 5800000,
            commissionRate: 2.5,
            commissionText: 'EGP 145K',
          ),
          UnitModel(
            code: 'A-1409',
            type: 'Duplex',
            price: 'EGP 7.5M',
            priceValue: 7500000,
            commissionRate: 2.5,
            commissionText: 'EGP 187.5K',
          ),
        ],
      ),
    ];
  }
}

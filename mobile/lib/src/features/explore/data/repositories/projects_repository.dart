import '../../domain/entities/project.dart';

class ProjectsRepository {
  const ProjectsRepository();

  List<Project> featuredProjects() {
    return const [
      Project(
        id: 'px-east-01',
        name: 'East Crown Residence',
        developer: 'Crown Developments',
        location: 'New Cairo',
        startingPrice: 'EGP 4.8M',
        downPayment: '10%',
        installmentYears: '8 years',
        delivery: '2028',
        commission: '3.5%',
        badge: 'Highest commission',
      ),
      Project(
        id: 'px-coast-02',
        name: 'North Bay Lagoon',
        developer: 'Blueline',
        location: 'North Coast',
        startingPrice: 'EGP 6.1M',
        downPayment: '5%',
        installmentYears: '7 years',
        delivery: 'Ready resale',
        commission: '2.25%',
        badge: 'Hot transfer',
      ),
      Project(
        id: 'px-west-03',
        name: 'West Yard Offices',
        developer: 'Axis Urban',
        location: 'Sheikh Zayed',
        startingPrice: 'EGP 3.2M',
        downPayment: '15%',
        installmentYears: '6 years',
        delivery: '2027',
        commission: '2.75%',
        badge: 'Verified stock',
      ),
    ];
  }
}

import '../../domain/entities/lead.dart';

class LeadsRepository {
  const LeadsRepository();

  List<Lead> activeLeads() {
    return const [
      Lead(
        name: 'Omar Adel',
        project: 'East Crown Residence',
        budget: 'EGP 5M',
        status: LeadStatus.protected,
        protectionEndsIn: '11 days',
      ),
      Lead(
        name: 'Mariam Samir',
        project: 'North Bay Lagoon',
        budget: 'EGP 6.5M',
        status: LeadStatus.siteVisit,
        protectionEndsIn: '4 days',
      ),
      Lead(
        name: 'Hussein Tarek',
        project: 'West Yard Offices',
        budget: 'EGP 3.5M',
        status: LeadStatus.followUp,
        protectionEndsIn: '8 days',
      ),
    ];
  }
}

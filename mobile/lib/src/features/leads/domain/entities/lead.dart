enum LeadStatus { protected, followUp, siteVisit, expired }

class Lead {
  const Lead({
    required this.name,
    required this.project,
    required this.budget,
    required this.status,
    required this.protectionEndsIn,
  });

  final String name;
  final String project;
  final String budget;
  final LeadStatus status;
  final String protectionEndsIn;
}

class BrokerContract {
  const BrokerContract({
    required this.clientName,
    required this.projectName,
    required this.unitCode,
    required this.contractValue,
    required this.commission,
    required this.status,
  });

  final String clientName;
  final String projectName;
  final String unitCode;
  final String contractValue;
  final String commission;
  final String status;
}

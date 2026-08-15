enum DealStage { documents, developerReview, transferSigning, commissionReady }

class Deal {
  const Deal({
    required this.buyer,
    required this.unit,
    required this.value,
    required this.commission,
    required this.stage,
  });

  final String buyer;
  final String unit;
  final String value;
  final String commission;
  final DealStage stage;
}

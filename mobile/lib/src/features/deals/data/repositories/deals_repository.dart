import '../../domain/entities/deal.dart';

class DealsRepository {
  const DealsRepository();

  List<Deal> activeDeals() {
    return const [
      Deal(
        buyer: 'Salma Nabil',
        unit: 'Crown A-1403',
        value: 'EGP 4.95M',
        commission: 'EGP 173K',
        stage: DealStage.developerReview,
      ),
      Deal(
        buyer: 'Ahmed Fathy',
        unit: 'Bay Villa 22',
        value: 'EGP 7.2M',
        commission: 'EGP 162K',
        stage: DealStage.documents,
      ),
      Deal(
        buyer: 'Nour Khaled',
        unit: 'Yard Office 508',
        value: 'EGP 3.4M',
        commission: 'EGP 93K',
        stage: DealStage.commissionReady,
      ),
    ];
  }
}

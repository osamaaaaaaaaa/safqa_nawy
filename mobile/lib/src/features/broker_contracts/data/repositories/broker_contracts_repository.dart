import '../../domain/entities/broker_contract.dart';

class BrokerContractsRepository {
  const BrokerContractsRepository();

  List<BrokerContract> activeContracts() {
    return const [
      BrokerContract(
        clientName: 'Omar Hassan',
        projectName: 'East Residence',
        unitCode: 'A-1407',
        contractValue: 'EGP 5.8M',
        commission: 'EGP 116K',
        status: 'Under review',
      ),
      BrokerContract(
        clientName: 'Mariam Adel',
        projectName: 'West Park',
        unitCode: 'T-22',
        contractValue: 'EGP 9.4M',
        commission: 'EGP 188K',
        status: 'Transfer booking',
      ),
    ];
  }
}

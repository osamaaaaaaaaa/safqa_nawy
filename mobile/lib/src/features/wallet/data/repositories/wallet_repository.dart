import '../../domain/entities/wallet_transaction.dart';

class WalletRepository {
  const WalletRepository();

  String get availableBalance => 'EGP 128,500';
  String get pendingBalance => 'EGP 254,000';
  String get paidThisMonth => 'EGP 82,000';

  List<WalletTransaction> transactions() {
    return const [
      WalletTransaction(
        title: 'Commission released',
        subtitle: 'Crown A-1403 transfer completed',
        amount: '+EGP 58,000',
        isCredit: true,
      ),
      WalletTransaction(
        title: 'Withdrawal',
        subtitle: 'Bank transfer ending 4219',
        amount: '-EGP 35,000',
        isCredit: false,
      ),
      WalletTransaction(
        title: 'Pending approval',
        subtitle: 'Bay Villa 22 developer sign-off',
        amount: 'EGP 162,000',
        isCredit: true,
      ),
    ];
  }
}

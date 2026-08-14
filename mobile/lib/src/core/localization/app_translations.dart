import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => const {
        'ar': {
          'app.name': '\u0635\u0641\u0642\u0629',
          'app.tagline':
              '\u0628\u0648\u0627\u0628\u0629 \u0627\u0644\u0628\u0631\u0648\u0643\u0631 \u0627\u0644\u062e\u0627\u0635\u0629',
          'home.hero.title':
              '\u0627\u0642\u0641\u0644 \u0639\u0642\u062f\u0643 \u0645\u0646 \u0645\u0643\u0627\u0646 \u0648\u0627\u062d\u062f',
          'home.hero.body':
              '\u0644\u0648 \u0645\u0639\u0627\u0643 \u0639\u0642\u062f \u0639\u0642\u0627\u0631\u064a \u0648\u0645\u062d\u062a\u0627\u062c \u0634\u0631\u0643\u0629 \u062a\u0642\u0641\u0644\u0647\u060c \u0635\u0641\u0642\u0629 \u062a\u0633\u062a\u0644\u0645 \u0627\u0644\u0645\u0644\u0641\u060c \u062a\u0631\u0627\u062c\u0639 \u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a\u060c \u0648\u062a\u062a\u0627\u0628\u0639 \u0627\u0644\u0625\u063a\u0644\u0627\u0642 \u0644\u062d\u062f \u0645\u0627 \u0639\u0645\u0648\u0644\u062a\u0643 \u062a\u0628\u0642\u0649 \u062c\u0627\u0647\u0632\u0629.',
          'home.hero.primaryAction':
              '\u0627\u0631\u0641\u0639 \u0639\u0642\u062f \u062c\u062f\u064a\u062f',
          'home.hero.secondaryAction':
              '\u062a\u0627\u0628\u0639 \u0639\u0642\u0648\u062f\u0643',
          'home.stats.verified':
              '\u0639\u0642\u0648\u062f \u0646\u0634\u0637\u0629',
          'home.stats.transfer':
              '\u0645\u062a\u0648\u0633\u0637 \u0627\u0644\u0625\u063a\u0644\u0627\u0642',
          'home.stats.brokers':
              '\u0639\u0645\u0648\u0644\u0627\u062a \u062c\u0627\u0647\u0632\u0629',
          'home.paths.title':
              '\u0627\u0644\u0645\u0633\u0627\u0631 \u0627\u0644\u062e\u0627\u0635',
          'home.paths.seller.title':
              '\u0627\u0631\u0641\u0639 \u0627\u0644\u0645\u0644\u0641',
          'home.paths.seller.body':
              '\u0627\u0636\u0641 \u0628\u064a\u0627\u0646\u0627\u062a \u0627\u0644\u0639\u0645\u064a\u0644\u060c \u0627\u0644\u0648\u062d\u062f\u0629\u060c \u0633\u0639\u0631 \u0627\u0644\u0639\u0642\u062f\u060c \u0648\u0645\u0633\u062a\u0646\u062f\u0627\u062a \u0627\u0644\u062d\u062c\u0632.',
          'home.paths.buyer.title':
              '\u0627\u0644\u0645\u0631\u0627\u062c\u0639\u0629 \u0648\u0627\u0644\u0645\u0637\u0627\u0628\u0642\u0629',
          'home.paths.buyer.body':
              '\u0641\u0631\u064a\u0642\u0646\u0627 \u064a\u0631\u0627\u062c\u0639 \u0627\u0644\u0639\u0642\u062f \u0648\u064a\u062a\u0623\u0643\u062f \u0645\u0646 \u0627\u0644\u0623\u0631\u0642\u0627\u0645 \u0642\u0628\u0644 \u0628\u062f\u0621 \u062e\u0637\u0648\u0627\u062a \u0627\u0644\u062a\u0646\u0627\u0632\u0644.',
          'home.paths.broker.title':
              '\u0627\u0633\u062a\u0644\u0645 \u0639\u0645\u0648\u0644\u062a\u0643',
          'home.paths.broker.body':
              '\u0628\u0639\u062f \u0627\u0644\u0625\u063a\u0644\u0627\u0642 \u062a\u0638\u0647\u0631 \u0639\u0645\u0648\u0644\u062a\u0643 \u0628\u0648\u0636\u0648\u062d \u0645\u0639 \u062d\u0627\u0644\u0629 \u0627\u0644\u0635\u0631\u0641.',
          'home.deals.title':
              '\u0639\u0642\u0648\u062f \u0642\u064a\u062f \u0627\u0644\u0625\u063a\u0644\u0627\u0642',
          'home.deals.subtitle':
              '\u0645\u0644\u062e\u0635 \u0633\u0631\u064a\u0639 \u0644\u0643\u0644 \u0645\u0644\u0641 \u0645\u0641\u062a\u0648\u062d.',
          'contract.client': '\u0627\u0644\u0639\u0645\u064a\u0644',
          'contract.value':
              '\u0642\u064a\u0645\u0629 \u0627\u0644\u0639\u0642\u062f',
          'contract.commission':
              '\u0627\u0644\u0639\u0645\u0648\u0644\u0629',
          'contract.status':
              '\u0627\u0644\u062d\u0627\u0644\u0629',
          'home.transfer.title':
              '\u062e\u0637\u0648\u0627\u062a \u0642\u0641\u0644 \u0627\u0644\u0639\u0642\u062f',
          'home.transfer.subtitle':
              '\u0645\u0646 \u0623\u0648\u0644 \u0631\u0641\u0639 \u0644\u062d\u062f \u0635\u0631\u0641 \u0627\u0644\u0639\u0645\u0648\u0644\u0629.',
          'transfer.docs.title':
              '\u062a\u0633\u0644\u064a\u0645 \u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a',
          'transfer.docs.body':
              '\u0627\u0644\u0639\u0642\u062f\u060c \u0627\u0644\u0625\u064a\u0635\u0627\u0644\u0627\u062a\u060c \u0648\u0628\u064a\u0627\u0646\u0627\u062a \u0627\u0644\u0637\u0631\u0641\u064a\u0646 \u0641\u064a \u0645\u0644\u0641 \u0648\u0627\u062d\u062f.',
          'transfer.match.title':
              '\u0645\u0631\u0627\u062c\u0639\u0629 \u0635\u0641\u0642\u0629',
          'transfer.match.body':
              '\u062a\u0623\u0643\u064a\u062f \u0627\u0644\u0623\u0631\u0642\u0627\u0645\u060c \u0627\u0644\u0645\u0642\u062f\u0645\u060c \u0627\u0644\u0645\u062a\u0628\u0642\u064a\u060c \u0648\u0634\u0631\u0648\u0637 \u0627\u0644\u062a\u0646\u0627\u0632\u0644.',
          'transfer.close.title':
              '\u0627\u0644\u0625\u063a\u0644\u0627\u0642 \u0648\u0627\u0644\u0635\u0631\u0641',
          'transfer.close.body':
              '\u0645\u062a\u0627\u0628\u0639\u0629 \u0627\u0644\u062a\u0646\u0627\u0632\u0644 \u0648\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u0639\u0645\u0648\u0644\u0629 \u0644\u0644\u0628\u0631\u0648\u0643\u0631.',
          'nav.home':
              '\u0627\u0644\u0644\u0648\u062d\u0629',
          'nav.deals':
              '\u0627\u0644\u0639\u0642\u0648\u062f',
          'nav.add':
              '\u062c\u062f\u064a\u062f',
          'nav.profile':
              '\u0627\u0644\u0645\u062d\u0641\u0638\u0629',
        },
        'en': {
          'app.name': 'Safqa',
          'app.tagline': 'Private broker portal',
          'home.hero.title': 'Close your contract from one place',
          'home.hero.body':
              'When you have a real estate contract that needs a company to close it, Safqa receives the file, verifies the documents, and follows the closing until your commission is ready.',
          'home.hero.primaryAction': 'Upload new contract',
          'home.hero.secondaryAction': 'Track contracts',
          'home.stats.verified': 'Active contracts',
          'home.stats.transfer': 'Average closing',
          'home.stats.brokers': 'Ready commission',
          'home.paths.title': 'Private workflow',
          'home.paths.seller.title': 'Upload the file',
          'home.paths.seller.body':
              'Add client details, unit data, contract value, and booking documents.',
          'home.paths.buyer.title': 'Review and match',
          'home.paths.buyer.body':
              'Our team reviews the contract and verifies the numbers before transfer steps begin.',
          'home.paths.broker.title': 'Receive commission',
          'home.paths.broker.body':
              'After closing, your commission appears clearly with payout status.',
          'home.deals.title': 'Contracts in closing',
          'home.deals.subtitle': 'A quick summary for every open file.',
          'contract.client': 'Client',
          'contract.value': 'Contract value',
          'contract.commission': 'Commission',
          'contract.status': 'Status',
          'home.transfer.title': 'Contract closing steps',
          'home.transfer.subtitle':
              'From upload to commission payout.',
          'transfer.docs.title': 'Submit documents',
          'transfer.docs.body':
              'Contract, receipts, and party details in one clean file.',
          'transfer.match.title': 'Safqa review',
          'transfer.match.body':
              'Confirm contract numbers, down payment, remaining amount, and transfer terms.',
          'transfer.close.title': 'Closing and payout',
          'transfer.close.body':
              'Follow the transfer and register the broker commission.',
          'nav.home': 'Dashboard',
          'nav.deals': 'Contracts',
          'nav.add': 'New',
          'nav.profile': 'Wallet',
        },
      };
}

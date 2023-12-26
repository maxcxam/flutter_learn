
import 'package:crypto_coins_list/features/crypto_coin/view/view.dart';
import 'package:crypto_coins_list/features/crypto_list/crypto_list.dart';

final routes = {
  '/':(context) => const CryptoListScreen(title: 'Crypto currencises list'),
  '/coin':(context) => const CryptoCoinScreen()
};
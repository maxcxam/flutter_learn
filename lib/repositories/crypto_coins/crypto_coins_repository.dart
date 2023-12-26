import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {

  const CryptoCoinsRepository({
    required this.dio
  });

  final Dio dio;

  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BNB,AVAX,DOT,SOL,XRP,USDC,OP,MATIC&tsyms=USD'
    );

    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinsList = dataRaw.entries
      .map((e) {
        final usdData = (e.value as Map<String, dynamic>)['USD'] as Map<String, dynamic>;
        final price = usdData['PRICE'];
        final imgUrl = usdData['IMAGEURL'];
        return CryptoCoin(
          name: e.key, 
          priceInUSD: double.parse(price.toStringAsFixed(2)),
          imageUrl: 'https://cryptocompare.com/$imgUrl'
        );
      }).toList();
    return cryptoCoinsList;
  }
}
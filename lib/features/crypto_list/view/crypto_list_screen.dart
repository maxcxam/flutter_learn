import 'dart:async';
import 'dart:ui';

import 'package:crypto_coins_list/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_coins_list/features/crypto_list/widgets.dart';
import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:crypto_coins_list/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key, required this.title});

  final String title;

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final CryptoListBloc _cryptoListBloc =
      CryptoListBloc(GetIt.I<AbstractCoinsRepository>());

  @override
  void initState() {
    _loadCryptoCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TalkerScreen(talker: GetIt.I<Talker>()))
                );
              }, 
              icon: const Icon(Icons.document_scanner_outlined)
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadCryptoCoins,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: BlocBuilder<CryptoListBloc, CryptoListState>(
              bloc: _cryptoListBloc,
              builder: (context, state) {
                if (state is CryptoListLoaded) {
                  return ListView.separated(
                      itemCount: state.coinsList.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final coin = state.coinsList[index];
                        return CryptoCoinTile(coin: coin);
                      });
                }

                if (state is CryptoListLoadingFailure) {
                  return Center(
                      child: Column(
                      children: [
                        Text(
                          'Something went wrong',
                          style: darkTheme.textTheme.headlineMedium,
                        ),
                        Text('Please try again later',
                            style: darkTheme.textTheme.labelSmall),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: _loadCryptoCoins,
                            child: const Text('Try again'))
                      ],
                    )
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ));
  }

  Future<Future> _loadCryptoCoins() async {
    final Completer completer = Completer();
    _cryptoListBloc.add(LoadCryptoList(completer: completer));
    return completer.future;
  }
}

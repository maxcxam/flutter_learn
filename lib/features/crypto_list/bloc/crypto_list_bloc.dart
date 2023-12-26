import 'dart:async';
import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
part 'crypto_list_event.dart';
part 'crypto_list_state.dart';

class CryptoListBloc extends Bloc<CryptoListEvent, CryptoListState> {
  CryptoListBloc(this.coinsRepository) : super(CryptoListInitial()) {
    on<LoadCryptoList>((event, emit) async {
      try {
        if(state is! CryptoListLoaded) {
          emit(CryptoListLoading());
        }
        final cryptoCoinsList = await coinsRepository.getCoinsList();
        emit(CryptoListLoaded(coinsList: cryptoCoinsList));
      } catch(e, st) {
        emit(CryptoListLoadingFailure(exception: e));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });
  }

  @override
  void onError(Object e, StackTrace st) {
    super.onError(e, st);
    GetIt.I<Talker>().handle(e, st);
  }

  final AbstractCoinsRepository coinsRepository;
}
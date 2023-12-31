
import 'dart:async';
import 'dart:ui';

import 'package:crypto_coins_list/crypto_coins_list_app.dart';
import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton<Talker>(talker);
  GetIt.I<Talker>().debug('Talker started');

  final dio = Dio();
  dio.interceptors.add(
    TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printResponseData: false,
        ),
    ),
  );
  GetIt.I.registerLazySingleton<AbstractCoinsRepository>(() => CryptoCoinsRepository(dio:dio));

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: false,
      printStateFullData: false,
    )
  );
  

  FlutterError.onError = (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  PlatformDispatcher.instance.onError = (e, st) {
    GetIt.I<Talker>().handle(e, st);
    return true;
  };

  runZonedGuarded(
    () => runApp(const CryptoCurrenciesListApp()), 
    (e, st) { GetIt.I<Talker>().handle(e, st); });
}
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/account_repository.dart';

part 'account_providers.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) =>
    AccountRepository(ref.watch(drsApiProvider).getAccountApi());

@riverpod
Future<Profile> profile(Ref ref) =>
    ref.watch(accountRepositoryProvider).profile();

@riverpod
Future<Map<String, String>> consents(Ref ref) =>
    ref.watch(accountRepositoryProvider).consents();

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider = SubscriptionRepositoryProvider._();

final class SubscriptionRepositoryProvider
    extends
        $FunctionalProvider<
          SubscriptionRepository,
          SubscriptionRepository,
          SubscriptionRepository
        >
    with $Provider<SubscriptionRepository> {
  SubscriptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubscriptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionRepository create(Ref ref) {
    return subscriptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionRepository>(value),
    );
  }
}

String _$subscriptionRepositoryHash() =>
    r'9931c98e79babaf6e467f546c5e72dfbc8a5bd97';

@ProviderFor(subscriptions)
final subscriptionsProvider = SubscriptionsProvider._();

final class SubscriptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<Subscription>>>,
          Cached<List<Subscription>>,
          FutureOr<Cached<List<Subscription>>>
        >
    with
        $FutureModifier<Cached<List<Subscription>>>,
        $FutureProvider<Cached<List<Subscription>>> {
  SubscriptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionsHash();

  @$internal
  @override
  $FutureProviderElement<Cached<List<Subscription>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<List<Subscription>>> create(Ref ref) {
    return subscriptions(ref);
  }
}

String _$subscriptionsHash() => r'0f09f55e797e07dfe85f097f06f096b5c335bb5a';

/// Effective quantities for tomorrow's (IST) delivery.

@ProviderFor(nextDeliveryPlan)
final nextDeliveryPlanProvider = NextDeliveryPlanFamily._();

/// Effective quantities for tomorrow's (IST) delivery.

final class NextDeliveryPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, double>>,
          Map<int, double>,
          FutureOr<Map<int, double>>
        >
    with $FutureModifier<Map<int, double>>, $FutureProvider<Map<int, double>> {
  /// Effective quantities for tomorrow's (IST) delivery.
  NextDeliveryPlanProvider._({
    required NextDeliveryPlanFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'nextDeliveryPlanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nextDeliveryPlanHash();

  @override
  String toString() {
    return r'nextDeliveryPlanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<int, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, double>> create(Ref ref) {
    final argument = this.argument as int;
    return nextDeliveryPlan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NextDeliveryPlanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nextDeliveryPlanHash() => r'5d5c978902e67adc63db0272cf82de2a3103ed14';

/// Effective quantities for tomorrow's (IST) delivery.

final class NextDeliveryPlanFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<int, double>>, int> {
  NextDeliveryPlanFamily._()
    : super(
        retry: null,
        name: r'nextDeliveryPlanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Effective quantities for tomorrow's (IST) delivery.

  NextDeliveryPlanProvider call(int subId) =>
      NextDeliveryPlanProvider._(argument: subId, from: this);

  @override
  String toString() => r'nextDeliveryPlanProvider';
}

/// Mutations on the standing order. Each one re-reads the latest template
/// from the server before replacing items, so edits made elsewhere (web app)
/// aren't overwritten with a stale copy. Kept alive: callers only `read` it,
/// and an auto-disposed notifier would be torn down mid-request.

@ProviderFor(SubscriptionActions)
final subscriptionActionsProvider = SubscriptionActionsProvider._();

/// Mutations on the standing order. Each one re-reads the latest template
/// from the server before replacing items, so edits made elsewhere (web app)
/// aren't overwritten with a stale copy. Kept alive: callers only `read` it,
/// and an auto-disposed notifier would be torn down mid-request.
final class SubscriptionActionsProvider
    extends $NotifierProvider<SubscriptionActions, void> {
  /// Mutations on the standing order. Each one re-reads the latest template
  /// from the server before replacing items, so edits made elsewhere (web app)
  /// aren't overwritten with a stale copy. Kept alive: callers only `read` it,
  /// and an auto-disposed notifier would be torn down mid-request.
  SubscriptionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionActionsHash();

  @$internal
  @override
  SubscriptionActions create() => SubscriptionActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$subscriptionActionsHash() =>
    r'94251fcb5fa06a69a2e56269cd1ab89f89708108';

/// Mutations on the standing order. Each one re-reads the latest template
/// from the server before replacing items, so edits made elsewhere (web app)
/// aren't overwritten with a stale copy. Kept alive: callers only `read` it,
/// and an auto-disposed notifier would be torn down mid-request.

abstract class _$SubscriptionActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

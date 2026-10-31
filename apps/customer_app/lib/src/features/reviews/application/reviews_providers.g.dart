// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewsRepository)
final reviewsRepositoryProvider = ReviewsRepositoryProvider._();

final class ReviewsRepositoryProvider
    extends
        $FunctionalProvider<
          ReviewsRepository,
          ReviewsRepository,
          ReviewsRepository
        >
    with $Provider<ReviewsRepository> {
  ReviewsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReviewsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReviewsRepository create(Ref ref) {
    return reviewsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewsRepository>(value),
    );
  }
}

String _$reviewsRepositoryHash() => r'43ffde34dfc565216176781692820b18d52a1f7f';

@ProviderFor(productReviews)
final productReviewsProvider = ProductReviewsFamily._();

final class ProductReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReviewSummary>,
          ReviewSummary,
          FutureOr<ReviewSummary>
        >
    with $FutureModifier<ReviewSummary>, $FutureProvider<ReviewSummary> {
  ProductReviewsProvider._({
    required ProductReviewsFamily super.from,
    required (int, {ReviewSort sort}) super.argument,
  }) : super(
         retry: null,
         name: r'productReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productReviewsHash();

  @override
  String toString() {
    return r'productReviewsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ReviewSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReviewSummary> create(Ref ref) {
    final argument = this.argument as (int, {ReviewSort sort});
    return productReviews(ref, argument.$1, sort: argument.sort);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productReviewsHash() => r'f7e474c972a5ac9d585d5b5b5c3bde1f0a29f795';

final class ProductReviewsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ReviewSummary>,
          (int, {ReviewSort sort})
        > {
  ProductReviewsFamily._()
    : super(
        retry: null,
        name: r'productReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductReviewsProvider call(
    int productId, {
    ReviewSort sort = ReviewSort.recent,
  }) => ProductReviewsProvider._(argument: (productId, sort: sort), from: this);

  @override
  String toString() => r'productReviewsProvider';
}

# drs_api.api.ReviewsApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteMyRating**](ReviewsApi.md#deletemyrating) | **DELETE** /api/v1/products/{product_id}/ratings | 
[**listProductRatings**](ReviewsApi.md#listproductratings) | **GET** /api/v1/products/{product_id}/ratings | 
[**rateProduct**](ReviewsApi.md#rateproduct) | **POST** /api/v1/products/{product_id}/ratings | 
[**toggleReviewHelpful**](ReviewsApi.md#togglereviewhelpful) | **POST** /api/v1/products/{product_id}/ratings/{rating_id}/helpful | 


# **deleteMyRating**
> deleteMyRating(productId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getReviewsApi();
final int productId = 56; // int | 

try {
    api.deleteMyRating(productId);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->deleteMyRating: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProductRatings**
> ProductRatingsOut listProductRatings(productId, sort, limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getReviewsApi();
final int productId = 56; // int | 
final String sort = sort_example; // String | recent (default) | helpful
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listProductRatings(productId, sort, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->listProductRatings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **int**|  | 
 **sort** | **String**| recent (default) | helpful | [optional] 
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**ProductRatingsOut**](ProductRatingsOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rateProduct**
> RatingOut rateProduct(productId, ratingIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getReviewsApi();
final int productId = 56; // int | 
final RatingIn ratingIn = ; // RatingIn | 

try {
    final response = api.rateProduct(productId, ratingIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->rateProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **int**|  | 
 **ratingIn** | [**RatingIn**](RatingIn.md)|  | 

### Return type

[**RatingOut**](RatingOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **toggleReviewHelpful**
> HelpfulOut toggleReviewHelpful(productId, ratingId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getReviewsApi();
final int productId = 56; // int | 
final int ratingId = 56; // int | 

try {
    final response = api.toggleReviewHelpful(productId, ratingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReviewsApi->toggleReviewHelpful: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **int**|  | 
 **ratingId** | **int**|  | 

### Return type

[**HelpfulOut**](HelpfulOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


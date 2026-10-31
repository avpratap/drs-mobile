# drs_api.api.DeliveryApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deliverOrder**](DeliveryApi.md#deliverorder) | **POST** /api/v1/delivery/orders/{order_id}/deliver | 
[**deliveryRoute**](DeliveryApi.md#deliveryroute) | **GET** /api/v1/delivery/orders/route | 
[**deliverySummary**](DeliveryApi.md#deliverysummary) | **GET** /api/v1/delivery/summary | 
[**failDeliveryOrder**](DeliveryApi.md#faildeliveryorder) | **POST** /api/v1/delivery/orders/{order_id}/fail | 
[**listDeliveryOrders**](DeliveryApi.md#listdeliveryorders) | **GET** /api/v1/delivery/orders | 
[**uploadPodAsset**](DeliveryApi.md#uploadpodasset) | **POST** /api/v1/delivery/uploads | 


# **deliverOrder**
> DeliveryOrderOut deliverOrder(orderId, deliverRequest, idempotencyKey)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final int orderId = 56; // int | 
final DeliverRequest deliverRequest = ; // DeliverRequest | 
final String idempotencyKey = idempotencyKey_example; // String | Opt-in at-most-once execution (the backend middleware replays a stored 2xx).

try {
    final response = api.deliverOrder(orderId, deliverRequest, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->deliverOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 
 **deliverRequest** | [**DeliverRequest**](DeliverRequest.md)|  | 
 **idempotencyKey** | **String**| Opt-in at-most-once execution (the backend middleware replays a stored 2xx). | [optional] 

### Return type

[**DeliveryOrderOut**](DeliveryOrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deliveryRoute**
> List<RouteStopOut> deliveryRoute(date)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final DateTime date = 2013-10-20; // DateTime | Delivery date (default tomorrow, IST)

try {
    final response = api.deliveryRoute(date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->deliveryRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**| Delivery date (default tomorrow, IST) | [optional] 

### Return type

[**List&lt;RouteStopOut&gt;**](RouteStopOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deliverySummary**
> DeliverySummaryOut deliverySummary(date)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final DateTime date = 2013-10-20; // DateTime | 

try {
    final response = api.deliverySummary(date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->deliverySummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**|  | [optional] 

### Return type

[**DeliverySummaryOut**](DeliverySummaryOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **failDeliveryOrder**
> DeliveryOrderOut failDeliveryOrder(orderId, failIn, idempotencyKey)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final int orderId = 56; // int | 
final FailIn failIn = ; // FailIn | 
final String idempotencyKey = idempotencyKey_example; // String | Opt-in at-most-once execution (the backend middleware replays a stored 2xx).

try {
    final response = api.failDeliveryOrder(orderId, failIn, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->failDeliveryOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 
 **failIn** | [**FailIn**](FailIn.md)|  | 
 **idempotencyKey** | **String**| Opt-in at-most-once execution (the backend middleware replays a stored 2xx). | [optional] 

### Return type

[**DeliveryOrderOut**](DeliveryOrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDeliveryOrders**
> List<DeliveryOrderOut> listDeliveryOrders(date, limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final DateTime date = 2013-10-20; // DateTime | Delivery date (default tomorrow, IST)
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listDeliveryOrders(date, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->listDeliveryOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**| Delivery date (default tomorrow, IST) | [optional] 
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**List&lt;DeliveryOrderOut&gt;**](DeliveryOrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadPodAsset**
> UploadOut uploadPodAsset(file)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDeliveryApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.uploadPodAsset(file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DeliveryApi->uploadPodAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**|  | 

### Return type

[**UploadOut**](UploadOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


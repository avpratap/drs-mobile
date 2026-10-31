# drs_api.api.OrdersApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelOrder**](OrdersApi.md#cancelorder) | **POST** /api/v1/orders/{order_id}/cancel | 
[**createOrder**](OrdersApi.md#createorder) | **POST** /api/v1/orders | 
[**getOrder**](OrdersApi.md#getorder) | **GET** /api/v1/orders/{order_id} | 
[**listOrders**](OrdersApi.md#listorders) | **GET** /api/v1/orders | 
[**trackOrder**](OrdersApi.md#trackorder) | **GET** /api/v1/orders/{order_id}/tracking | 


# **cancelOrder**
> OrderOut cancelOrder(orderId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getOrdersApi();
final int orderId = 56; // int | 

try {
    final response = api.cancelOrder(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OrdersApi->cancelOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 

### Return type

[**OrderOut**](OrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createOrder**
> OrderOut createOrder(idempotencyKey, orderCreate)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getOrdersApi();
final String idempotencyKey = idempotencyKey_example; // String | Client-generated UUID; a retried request replays instead of re-applying.
final OrderCreate orderCreate = ; // OrderCreate | 

try {
    final response = api.createOrder(idempotencyKey, orderCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OrdersApi->createOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client-generated UUID; a retried request replays instead of re-applying. | 
 **orderCreate** | [**OrderCreate**](OrderCreate.md)|  | 

### Return type

[**OrderOut**](OrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrder**
> OrderOut getOrder(orderId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getOrdersApi();
final int orderId = 56; // int | 

try {
    final response = api.getOrder(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OrdersApi->getOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 

### Return type

[**OrderOut**](OrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listOrders**
> List<OrderOut> listOrders(limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getOrdersApi();
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listOrders(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OrdersApi->listOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**List&lt;OrderOut&gt;**](OrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackOrder**
> OrderTrackingOut trackOrder(orderId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getOrdersApi();
final int orderId = 56; // int | 

try {
    final response = api.trackOrder(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling OrdersApi->trackOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **int**|  | 

### Return type

[**OrderTrackingOut**](OrderTrackingOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


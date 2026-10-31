# drs_api.api.DeliveryApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deliverySummary**](DeliveryApi.md#deliverysummary) | **GET** /api/v1/delivery/summary | 
[**listDeliveryOrders**](DeliveryApi.md#listdeliveryorders) | **GET** /api/v1/delivery/orders | 


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


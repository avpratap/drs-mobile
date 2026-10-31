# drs_api.api.DevicesApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**registerDeviceToken**](DevicesApi.md#registerdevicetoken) | **POST** /api/v1/account/device-tokens | 
[**unregisterDeviceTokenBody**](DevicesApi.md#unregisterdevicetokenbody) | **POST** /api/v1/account/device-tokens/unregister | 


# **registerDeviceToken**
> DeviceTokenOut registerDeviceToken(deviceTokenIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDevicesApi();
final DeviceTokenIn deviceTokenIn = ; // DeviceTokenIn | 

try {
    final response = api.registerDeviceToken(deviceTokenIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DevicesApi->registerDeviceToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceTokenIn** | [**DeviceTokenIn**](DeviceTokenIn.md)|  | 

### Return type

[**DeviceTokenOut**](DeviceTokenOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unregisterDeviceTokenBody**
> unregisterDeviceTokenBody(deviceTokenUnregisterIn)



Deactivate a token sent in the BODY (keeps the token out of URLs and logs).

### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getDevicesApi();
final DeviceTokenUnregisterIn deviceTokenUnregisterIn = ; // DeviceTokenUnregisterIn | 

try {
    api.unregisterDeviceTokenBody(deviceTokenUnregisterIn);
} on DioException catch (e) {
    print('Exception when calling DevicesApi->unregisterDeviceTokenBody: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceTokenUnregisterIn** | [**DeviceTokenUnregisterIn**](DeviceTokenUnregisterIn.md)|  | 

### Return type

void (empty response body)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


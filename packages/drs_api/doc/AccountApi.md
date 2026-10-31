# drs_api.api.AccountApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAddress**](AccountApi.md#createaddress) | **POST** /api/v1/addresses | 
[**getProfile**](AccountApi.md#getprofile) | **GET** /api/v1/profile | 
[**listAddresses**](AccountApi.md#listaddresses) | **GET** /api/v1/addresses | 
[**setDefaultAddress**](AccountApi.md#setdefaultaddress) | **POST** /api/v1/addresses/{address_id}/default | 


# **createAddress**
> AddressOut createAddress(addressIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final AddressIn addressIn = ; // AddressIn | 

try {
    final response = api.createAddress(addressIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->createAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressIn** | [**AddressIn**](AddressIn.md)|  | 

### Return type

[**AddressOut**](AddressOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProfile**
> ProfileOut getProfile()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();

try {
    final response = api.getProfile();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->getProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProfileOut**](ProfileOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAddresses**
> List<AddressOut> listAddresses()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();

try {
    final response = api.listAddresses();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->listAddresses: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;AddressOut&gt;**](AddressOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setDefaultAddress**
> AddressOut setDefaultAddress(addressId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final int addressId = 56; // int | 

try {
    final response = api.setDefaultAddress(addressId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->setDefaultAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **int**|  | 

### Return type

[**AddressOut**](AddressOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


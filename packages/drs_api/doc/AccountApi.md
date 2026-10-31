# drs_api.api.AccountApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAddress**](AccountApi.md#createaddress) | **POST** /api/v1/addresses | 
[**deleteAddress**](AccountApi.md#deleteaddress) | **DELETE** /api/v1/addresses/{address_id} | 
[**getConsents**](AccountApi.md#getconsents) | **GET** /api/v1/consents | 
[**getProfile**](AccountApi.md#getprofile) | **GET** /api/v1/profile | 
[**listAddresses**](AccountApi.md#listaddresses) | **GET** /api/v1/addresses | 
[**recordConsent**](AccountApi.md#recordconsent) | **POST** /api/v1/consents | 
[**setDefaultAddress**](AccountApi.md#setdefaultaddress) | **POST** /api/v1/addresses/{address_id}/default | 
[**updateAddress**](AccountApi.md#updateaddress) | **PATCH** /api/v1/addresses/{address_id} | 
[**updateProfile**](AccountApi.md#updateprofile) | **PATCH** /api/v1/profile | 


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

# **deleteAddress**
> deleteAddress(addressId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final int addressId = 56; // int | 

try {
    api.deleteAddress(addressId);
} on DioException catch (e) {
    print('Exception when calling AccountApi->deleteAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConsents**
> Map<String, String> getConsents()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();

try {
    final response = api.getConsents();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->getConsents: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Map&lt;String, String&gt;**

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **recordConsent**
> ConsentOut recordConsent(consentIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final ConsentIn consentIn = ; // ConsentIn | 

try {
    final response = api.recordConsent(consentIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->recordConsent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **consentIn** | [**ConsentIn**](ConsentIn.md)|  | 

### Return type

[**ConsentOut**](ConsentOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **updateAddress**
> AddressOut updateAddress(addressId, addressUpdate)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final int addressId = 56; // int | 
final AddressUpdate addressUpdate = ; // AddressUpdate | 

try {
    final response = api.updateAddress(addressId, addressUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->updateAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **int**|  | 
 **addressUpdate** | [**AddressUpdate**](AddressUpdate.md)|  | 

### Return type

[**AddressOut**](AddressOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProfile**
> ProfileOut updateProfile(profileUpdate)



Partial update (only sent fields change). Changing email resets verification.

### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAccountApi();
final ProfileUpdate profileUpdate = ; // ProfileUpdate | 

try {
    final response = api.updateProfile(profileUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AccountApi->updateProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profileUpdate** | [**ProfileUpdate**](ProfileUpdate.md)|  | 

### Return type

[**ProfileOut**](ProfileOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


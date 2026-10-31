# drs_api.api.AuthApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMe**](AuthApi.md#getme) | **GET** /api/v1/auth/me | 
[**logout**](AuthApi.md#logout) | **POST** /api/v1/auth/logout | 
[**refreshToken**](AuthApi.md#refreshtoken) | **POST** /api/v1/auth/refresh | 
[**requestOtp**](AuthApi.md#requestotp) | **POST** /api/v1/auth/otp/request | 
[**verifyOtp**](AuthApi.md#verifyotp) | **POST** /api/v1/auth/otp/verify | 


# **getMe**
> UserOut getMe()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAuthApi();

try {
    final response = api.getMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->getMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> DetailOut logout(refreshRequest)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAuthApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.logout(refreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->logout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**DetailOut**](DetailOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshToken**
> TokenPair refreshToken(refreshRequest)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAuthApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.refreshToken(refreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->refreshToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**TokenPair**](TokenPair.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestOtp**
> OTPRequestResponse requestOtp(oTPRequest)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAuthApi();
final OTPRequest oTPRequest = ; // OTPRequest | 

try {
    final response = api.requestOtp(oTPRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->requestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **oTPRequest** | [**OTPRequest**](OTPRequest.md)|  | 

### Return type

[**OTPRequestResponse**](OTPRequestResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyOtp**
> TokenPair verifyOtp(oTPVerify)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getAuthApi();
final OTPVerify oTPVerify = ; // OTPVerify | 

try {
    final response = api.verifyOtp(oTPVerify);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->verifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **oTPVerify** | [**OTPVerify**](OTPVerify.md)|  | 

### Return type

[**TokenPair**](TokenPair.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


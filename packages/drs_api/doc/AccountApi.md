# drs_api.api.AccountApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getProfile**](AccountApi.md#getprofile) | **GET** /api/v1/profile | 


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


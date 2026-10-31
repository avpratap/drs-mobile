# drs_api.api.PaymentsApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createPayment**](PaymentsApi.md#createpayment) | **POST** /api/v1/payments/create | 
[**verifyPayment**](PaymentsApi.md#verifypayment) | **POST** /api/v1/payments/verify | 


# **createPayment**
> PaymentCreateOut createPayment(idempotencyKey, paymentCreate)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getPaymentsApi();
final String idempotencyKey = idempotencyKey_example; // String | Client-generated UUID; a retried request replays instead of re-applying.
final PaymentCreate paymentCreate = ; // PaymentCreate | 

try {
    final response = api.createPayment(idempotencyKey, paymentCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->createPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client-generated UUID; a retried request replays instead of re-applying. | 
 **paymentCreate** | [**PaymentCreate**](PaymentCreate.md)|  | 

### Return type

[**PaymentCreateOut**](PaymentCreateOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyPayment**
> PaymentVerifyOut verifyPayment(paymentVerify)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getPaymentsApi();
final PaymentVerify paymentVerify = ; // PaymentVerify | 

try {
    final response = api.verifyPayment(paymentVerify);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->verifyPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentVerify** | [**PaymentVerify**](PaymentVerify.md)|  | 

### Return type

[**PaymentVerifyOut**](PaymentVerifyOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


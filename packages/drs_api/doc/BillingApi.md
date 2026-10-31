# drs_api.api.BillingApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**myBilling**](BillingApi.md#mybilling) | **GET** /api/v1/billing/me | 
[**myWalletTransactions**](BillingApi.md#mywallettransactions) | **GET** /api/v1/billing/transactions | 


# **myBilling**
> BillingSummary myBilling()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getBillingApi();

try {
    final response = api.myBilling();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BillingApi->myBilling: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BillingSummary**](BillingSummary.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myWalletTransactions**
> List<WalletTxnLineOut> myWalletTransactions(limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getBillingApi();
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.myWalletTransactions(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BillingApi->myWalletTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**List&lt;WalletTxnLineOut&gt;**](WalletTxnLineOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


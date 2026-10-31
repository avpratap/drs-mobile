# drs_api.api.SubscriptionsApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelSubscription**](SubscriptionsApi.md#cancelsubscription) | **POST** /api/v1/subscriptions/{sub_id}/cancel | 
[**createSubscription**](SubscriptionsApi.md#createsubscription) | **POST** /api/v1/subscriptions | 
[**getSubscription**](SubscriptionsApi.md#getsubscription) | **GET** /api/v1/subscriptions/{sub_id} | 
[**getSubscriptionPlan**](SubscriptionsApi.md#getsubscriptionplan) | **GET** /api/v1/subscriptions/{sub_id}/plan | 
[**listSubscriptions**](SubscriptionsApi.md#listsubscriptions) | **GET** /api/v1/subscriptions | 
[**pauseSubscription**](SubscriptionsApi.md#pausesubscription) | **POST** /api/v1/subscriptions/{sub_id}/pause | 
[**resumeSubscription**](SubscriptionsApi.md#resumesubscription) | **POST** /api/v1/subscriptions/{sub_id}/resume | 
[**setOverride**](SubscriptionsApi.md#setoverride) | **POST** /api/v1/subscriptions/{sub_id}/overrides | 
[**setSubscriptionItems**](SubscriptionsApi.md#setsubscriptionitems) | **PUT** /api/v1/subscriptions/{sub_id}/items | 


# **cancelSubscription**
> SubscriptionOut cancelSubscription(subId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 

try {
    final response = api.cancelSubscription(subId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->cancelSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 

### Return type

[**SubscriptionOut**](SubscriptionOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSubscription**
> SubscriptionOut createSubscription(subscriptionCreate)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final SubscriptionCreate subscriptionCreate = ; // SubscriptionCreate | 

try {
    final response = api.createSubscription(subscriptionCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->createSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionCreate** | [**SubscriptionCreate**](SubscriptionCreate.md)|  | 

### Return type

[**SubscriptionOut**](SubscriptionOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSubscription**
> SubscriptionDetail getSubscription(subId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 

try {
    final response = api.getSubscription(subId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->getSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 

### Return type

[**SubscriptionDetail**](SubscriptionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSubscriptionPlan**
> PlanOut getSubscriptionPlan(subId, date)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 
final DateTime date = 2013-10-20; // DateTime | 

try {
    final response = api.getSubscriptionPlan(subId, date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->getSubscriptionPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 
 **date** | **DateTime**|  | [optional] 

### Return type

[**PlanOut**](PlanOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSubscriptions**
> List<SubscriptionOut> listSubscriptions(limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listSubscriptions(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->listSubscriptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**List&lt;SubscriptionOut&gt;**](SubscriptionOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pauseSubscription**
> SubscriptionOut pauseSubscription(subId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 

try {
    final response = api.pauseSubscription(subId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->pauseSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 

### Return type

[**SubscriptionOut**](SubscriptionOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resumeSubscription**
> SubscriptionOut resumeSubscription(subId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 

try {
    final response = api.resumeSubscription(subId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->resumeSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 

### Return type

[**SubscriptionOut**](SubscriptionOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setOverride**
> OverrideSavedOut setOverride(subId, overrideIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 
final OverrideIn overrideIn = ; // OverrideIn | 

try {
    final response = api.setOverride(subId, overrideIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->setOverride: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 
 **overrideIn** | [**OverrideIn**](OverrideIn.md)|  | 

### Return type

[**OverrideSavedOut**](OverrideSavedOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setSubscriptionItems**
> SubscriptionDetail setSubscriptionItems(subId, subscriptionItemIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getSubscriptionsApi();
final int subId = 56; // int | 
final List<SubscriptionItemIn> subscriptionItemIn = ; // List<SubscriptionItemIn> | 

try {
    final response = api.setSubscriptionItems(subId, subscriptionItemIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubscriptionsApi->setSubscriptionItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subId** | **int**|  | 
 **subscriptionItemIn** | [**List&lt;SubscriptionItemIn&gt;**](SubscriptionItemIn.md)|  | 

### Return type

[**SubscriptionDetail**](SubscriptionDetail.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


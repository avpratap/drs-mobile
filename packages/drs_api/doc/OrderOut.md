# drs_api.model.OrderOut

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**orderNo** | **String** |  | 
**shopId** | **int** |  | 
**orderType** | **String** |  | 
**status** | **String** |  | 
**subtotal** | **num** |  | 
**total** | **num** |  | 
**paymentStatus** | **String** |  | 
**discount** | **num** |  | [optional] [default to 0]
**couponCode** | **String** |  | [optional] 
**taxTotal** | **num** |  | [optional] [default to 0]
**totalInclTax** | **num** |  | [optional] [default to 0]
**items** | [**List&lt;OrderItemOut&gt;**](OrderItemOut.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



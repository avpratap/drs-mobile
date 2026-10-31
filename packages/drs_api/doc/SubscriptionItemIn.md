# drs_api.model.SubscriptionItemIn

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **int** |  | 
**defaultQty** | **num** |  | 
**frequency** | **String** | daily | alternate | weekly | [optional] [default to 'daily']
**intervalDays** | **int** |  | [optional] 
**daysOfWeek** | **String** | CSV of ISO weekdays, e.g. \"1,3,5\" | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



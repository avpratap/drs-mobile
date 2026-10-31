# drs_api.model.ProductOut

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**sku** | **String** |  | 
**name** | **String** |  | 
**status** | **String** |  | 
**description** | **String** |  | [optional] 
**uom** | **String** |  | [optional] [default to 'piece']
**packSize** | **num** |  | [optional] [default to 1]
**isSubscribable** | **bool** |  | [optional] [default to true]
**perishable** | **bool** |  | [optional] [default to true]
**hsnCode** | **String** |  | [optional] 
**gstRate** | **num** |  | [optional] [default to 0]
**category** | **String** |  | [optional] 
**imageUrl** | **String** |  | [optional] 
**fromPrice** | **num** | Lowest GST-inclusive retail price (INR) | [optional] 
**avgRating** | **num** |  | [optional] [default to 0]
**ratingCount** | **int** |  | [optional] [default to 0]
**weightKg** | **num** |  | [optional] 
**lengthCm** | **num** |  | [optional] 
**widthCm** | **num** |  | [optional] 
**heightCm** | **num** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



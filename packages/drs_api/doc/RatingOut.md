# drs_api.model.RatingOut

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**productId** | **int** |  | 
**stars** | **int** |  | 
**status** | **String** | approved | pending | rejected | 
**verifiedPurchase** | **bool** |  | 
**helpfulCount** | **int** |  | 
**userId** | **int** | Only for the author (PII) | [optional] 
**mine** | **bool** |  | [optional] [default to false]
**comment** | **String** |  | [optional] 
**adminReply** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



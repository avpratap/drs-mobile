# drs_api.model.ProductRatingsOut

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **int** |  | 
**count** | **int** |  | 
**average** | **num** |  | 
**distribution** | **Map&lt;String, int&gt;** | stars (\"1\"..\"5\") -> count of approved reviews | 
**ratings** | [**List&lt;RatingOut&gt;**](RatingOut.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



# drs_api.model.VariantOut

## Load the model package
```dart
import 'package:drs_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**productId** | **int** |  | 
**sku** | **String** |  | 
**label** | **String** |  | 
**packSize** | **num** | Cart qty for one pack, in the product uom | 
**price** | **num** | Legacy catalogue field — do NOT display; use selling_price | 
**status** | **String** |  | 
**sortOrder** | **int** |  | 
**mrp** | **num** |  | [optional] 
**imageUrl** | **String** |  | [optional] 
**sellingPrice** | **num** | GST-inclusive storefront price of this pack | [optional] 
**priceAvailable** | **bool** |  | [optional] 
**showMrpStrike** | **bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



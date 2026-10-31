# drs_api.api.ProductsApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getProduct**](ProductsApi.md#getproduct) | **GET** /api/v1/products/{product_id} | 
[**listProductCategories**](ProductsApi.md#listproductcategories) | **GET** /api/v1/products/categories | 
[**listProducts**](ProductsApi.md#listproducts) | **GET** /api/v1/products | 


# **getProduct**
> ProductOut getProduct(productId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getProductsApi();
final int productId = 56; // int | 

try {
    final response = api.getProduct(productId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->getProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **int**|  | 

### Return type

[**ProductOut**](ProductOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProductCategories**
> List<String> listProductCategories()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getProductsApi();

try {
    final response = api.listProductCategories();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->listProductCategories: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProducts**
> List<ProductOut> listProducts(category, q, sort, perishable, inStock, limit, offset)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getProductsApi();
final String category = category_example; // String | 
final String q = q_example; // String | 
final String sort = sort_example; // String | newest | rating | name (default id asc)
final bool perishable = true; // bool | 
final bool inStock = true; // bool | 
final int limit = 56; // int | 
final int offset = 56; // int | 

try {
    final response = api.listProducts(category, q, sort, perishable, inStock, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProductsApi->listProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | **String**|  | [optional] 
 **q** | **String**|  | [optional] 
 **sort** | **String**| newest | rating | name (default id asc) | [optional] 
 **perishable** | **bool**|  | [optional] 
 **inStock** | **bool**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 50]
 **offset** | **int**|  | [optional] [default to 0]

### Return type

[**List&lt;ProductOut&gt;**](ProductOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


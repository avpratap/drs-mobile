# drs_api.api.CartApi

## Load the API package
```dart
import 'package:drs_api/api.dart';
```

All URIs are relative to *http://localhost:8000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addCartItem**](CartApi.md#addcartitem) | **POST** /api/v1/cart/items | 
[**cartQuote**](CartApi.md#cartquote) | **POST** /api/v1/cart/quote | 
[**checkoutCart**](CartApi.md#checkoutcart) | **POST** /api/v1/cart/checkout | 
[**getCart**](CartApi.md#getcart) | **GET** /api/v1/cart | 
[**removeCartItem**](CartApi.md#removecartitem) | **DELETE** /api/v1/cart/items/{item_id} | 
[**setCartItemQty**](CartApi.md#setcartitemqty) | **PATCH** /api/v1/cart/items/{item_id} | 


# **addCartItem**
> CartOut addCartItem(cartItemIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();
final CartItemIn cartItemIn = ; // CartItemIn | 

try {
    final response = api.addCartItem(cartItemIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->addCartItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cartItemIn** | [**CartItemIn**](CartItemIn.md)|  | 

### Return type

[**CartOut**](CartOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartQuote**
> QuoteOut cartQuote(quoteIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();
final QuoteIn quoteIn = ; // QuoteIn | 

try {
    final response = api.cartQuote(quoteIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->cartQuote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteIn** | [**QuoteIn**](QuoteIn.md)|  | 

### Return type

[**QuoteOut**](QuoteOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **checkoutCart**
> OrderOut checkoutCart(idempotencyKey, checkoutIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();
final String idempotencyKey = idempotencyKey_example; // String | Client-generated UUID; a retried request replays instead of re-applying.
final CheckoutIn checkoutIn = ; // CheckoutIn | 

try {
    final response = api.checkoutCart(idempotencyKey, checkoutIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->checkoutCart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client-generated UUID; a retried request replays instead of re-applying. | 
 **checkoutIn** | [**CheckoutIn**](CheckoutIn.md)|  | 

### Return type

[**OrderOut**](OrderOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCart**
> CartOut getCart()



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();

try {
    final response = api.getCart();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->getCart: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CartOut**](CartOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeCartItem**
> CartOut removeCartItem(itemId)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();
final int itemId = 56; // int | 

try {
    final response = api.removeCartItem(itemId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->removeCartItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **int**|  | 

### Return type

[**CartOut**](CartOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setCartItemQty**
> CartOut setCartItemQty(itemId, cartItemQtyIn)



### Example
```dart
import 'package:drs_api/api.dart';

final api = DrsApi().getCartApi();
final int itemId = 56; // int | 
final CartItemQtyIn cartItemQtyIn = ; // CartItemQtyIn | 

try {
    final response = api.setCartItemQty(itemId, cartItemQtyIn);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CartApi->setCartItemQty: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **int**|  | 
 **cartItemQtyIn** | [**CartItemQtyIn**](CartItemQtyIn.md)|  | 

### Return type

[**CartOut**](CartOut.md)

### Authorization

[HTTPBearer](../README.md#HTTPBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


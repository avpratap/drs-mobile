import 'package:drs_api/src/model/address_in.dart';
import 'package:drs_api/src/model/address_out.dart';
import 'package:drs_api/src/model/billing_summary.dart';
import 'package:drs_api/src/model/cart_item_in.dart';
import 'package:drs_api/src/model/cart_item_qty_in.dart';
import 'package:drs_api/src/model/cart_line_out.dart';
import 'package:drs_api/src/model/cart_out.dart';
import 'package:drs_api/src/model/checkout_in.dart';
import 'package:drs_api/src/model/deliver_item.dart';
import 'package:drs_api/src/model/deliver_request.dart';
import 'package:drs_api/src/model/delivery_order_item_out.dart';
import 'package:drs_api/src/model/delivery_order_out.dart';
import 'package:drs_api/src/model/delivery_summary_out.dart';
import 'package:drs_api/src/model/detail_out.dart';
import 'package:drs_api/src/model/fail_in.dart';
import 'package:drs_api/src/model/http_validation_error.dart';
import 'package:drs_api/src/model/otp_request.dart';
import 'package:drs_api/src/model/otp_request_response.dart';
import 'package:drs_api/src/model/otp_verify.dart';
import 'package:drs_api/src/model/order_create.dart';
import 'package:drs_api/src/model/order_item_in.dart';
import 'package:drs_api/src/model/order_item_out.dart';
import 'package:drs_api/src/model/order_out.dart';
import 'package:drs_api/src/model/order_tracking_out.dart';
import 'package:drs_api/src/model/override_in.dart';
import 'package:drs_api/src/model/override_saved_out.dart';
import 'package:drs_api/src/model/podin.dart';
import 'package:drs_api/src/model/payment_create.dart';
import 'package:drs_api/src/model/payment_create_out.dart';
import 'package:drs_api/src/model/payment_verify.dart';
import 'package:drs_api/src/model/payment_verify_out.dart';
import 'package:drs_api/src/model/plan_line.dart';
import 'package:drs_api/src/model/plan_out.dart';
import 'package:drs_api/src/model/product_full_out.dart';
import 'package:drs_api/src/model/product_out.dart';
import 'package:drs_api/src/model/profile_out.dart';
import 'package:drs_api/src/model/quote_in.dart';
import 'package:drs_api/src/model/quote_line_out.dart';
import 'package:drs_api/src/model/quote_out.dart';
import 'package:drs_api/src/model/refresh_request.dart';
import 'package:drs_api/src/model/route_stop_out.dart';
import 'package:drs_api/src/model/shipment_track_out.dart';
import 'package:drs_api/src/model/subscription_create.dart';
import 'package:drs_api/src/model/subscription_detail.dart';
import 'package:drs_api/src/model/subscription_item_in.dart';
import 'package:drs_api/src/model/subscription_item_out.dart';
import 'package:drs_api/src/model/subscription_out.dart';
import 'package:drs_api/src/model/token_pair.dart';
import 'package:drs_api/src/model/tracking_event_out.dart';
import 'package:drs_api/src/model/upload_out.dart';
import 'package:drs_api/src/model/user_out.dart';
import 'package:drs_api/src/model/validation_error_item.dart';
import 'package:drs_api/src/model/variant_out.dart';
import 'package:drs_api/src/model/wallet_txn_line_out.dart';
import 'package:drs_api/src/model/wallet_txn_out.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AddressIn':
          return AddressIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AddressOut':
          return AddressOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BillingSummary':
          return BillingSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CartItemIn':
          return CartItemIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CartItemQtyIn':
          return CartItemQtyIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CartLineOut':
          return CartLineOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CartOut':
          return CartOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CheckoutIn':
          return CheckoutIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeliverItem':
          return DeliverItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeliverRequest':
          return DeliverRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeliveryOrderItemOut':
          return DeliveryOrderItemOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeliveryOrderOut':
          return DeliveryOrderOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeliverySummaryOut':
          return DeliverySummaryOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DetailOut':
          return DetailOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FailIn':
          return FailIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HTTPValidationError':
          return HTTPValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OTPRequest':
          return OTPRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OTPRequestResponse':
          return OTPRequestResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OTPVerify':
          return OTPVerify.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderCreate':
          return OrderCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderItemIn':
          return OrderItemIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderItemOut':
          return OrderItemOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderOut':
          return OrderOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OrderTrackingOut':
          return OrderTrackingOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OverrideIn':
          return OverrideIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OverrideSavedOut':
          return OverrideSavedOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PODIn':
          return PODIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PaymentCreate':
          return PaymentCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PaymentCreateOut':
          return PaymentCreateOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PaymentVerify':
          return PaymentVerify.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PaymentVerifyOut':
          return PaymentVerifyOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PlanLine':
          return PlanLine.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PlanOut':
          return PlanOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductFullOut':
          return ProductFullOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProductOut':
          return ProductOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProfileOut':
          return ProfileOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuoteIn':
          return QuoteIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuoteLineOut':
          return QuoteLineOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuoteOut':
          return QuoteOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshRequest':
          return RefreshRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RouteStopOut':
          return RouteStopOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ShipmentTrackOut':
          return ShipmentTrackOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscriptionCreate':
          return SubscriptionCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscriptionDetail':
          return SubscriptionDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscriptionItemIn':
          return SubscriptionItemIn.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscriptionItemOut':
          return SubscriptionItemOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscriptionOut':
          return SubscriptionOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokenPair':
          return TokenPair.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrackingEventOut':
          return TrackingEventOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadOut':
          return UploadOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserOut':
          return UserOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationErrorItem':
          return ValidationErrorItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VariantOut':
          return VariantOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WalletTxnLineOut':
          return WalletTxnLineOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WalletTxnOut':
          return WalletTxnOut.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }
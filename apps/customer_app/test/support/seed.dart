import 'fake_drs_server.dart';

/// A populated account: cart, address, a paid + an unpaid order, and an
/// active standing order.
FakeDrsServer seededServer() {
  final s = FakeDrsServer()
    ..seedCart(2, 1.5)
    ..seedCart(3, 0.4);
  s.addresses.add({
    'id': 1,
    'account_id': 1,
    'label': 'Home',
    'contact_name': 'Asha Devi',
    'contact_phone': '+919876543210',
    'line1': '12 Gandhi Path',
    'landmark': 'Govind Dev Ji Temple',
    'city': 'Jaipur',
    'state': 'Rajasthan',
    'pincode': '302001',
    'country': 'IN',
    'is_default': true,
    'status': 'active',
  });
  s.orders.addAll([
    {
      'id': 2,
      'order_no': 'DRS-002',
      'shop_id': 1,
      'order_type': 'd2c',
      'status': 'created',
      'payment_status': 'pending',
      'subtotal': 96,
      'discount': 0,
      'total': 96,
      'tax_total': 1.43,
      'items': [
        {'product_id': 2, 'qty': 1, 'unit_price': 64, 'line_total': 64},
        {
          'product_id': 3,
          'qty': 0.4,
          'unit_price': 75,
          'line_total': 30,
          'gst_rate': 5,
          'gst_amount': 1.43,
        },
      ],
    },
    {
      'id': 1,
      'order_no': 'DRS-001',
      'shop_id': 1,
      'order_type': 'd2c',
      'status': 'confirmed',
      'payment_status': 'paid',
      'subtotal': 749,
      'discount': 0,
      'total': 749,
      'tax_total': 80.25,
      'items': [
        {
          'product_id': 1,
          'qty': 0.5,
          'unit_price': 1498,
          'line_total': 749,
          'gst_rate': 12,
          'gst_amount': 80.25,
        },
      ],
    },
  ]);
  s.subscription = {
    'id': 5,
    'shop_id': 9,
    'account_id': 1,
    'status': 'active',
    'start_date': '2026-10-31',
    'items': [
      {
        'id': 1,
        'product_id': 2,
        'default_qty': 1,
        'frequency': 'daily',
        'active': true,
      },
      {
        'id': 2,
        'product_id': 3,
        'default_qty': 0.4,
        'frequency': 'weekly',
        'days_of_week': '6,7',
        'active': true,
      },
    ],
  };
  return s;
}

import 'dart:async';

import 'api.dart';
import 'db.dart';

import '../models/response.dart';
import '../utilities/constanst.dart';

class OrderService {
  Future<Respuesta> getOptions(String? sku) async {
    try {
      final options = await get('', 'integration', 'products/$sku/options');
      if (options.isNotEmpty) {
        return Respuesta(result: 'ok', data: {"data": options}, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> getSlot(String? id) async {
    try {
      final slot = await get('', '', 'restaurant/product/$id');
      if (slot.isNotEmpty) {
        return Respuesta(
            result: 'ok', data: {"data": slot[0]['info']}, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> createCart() async {
    try {
      final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
      return await post(sesion[0]['token'], 'custom', 'carts/mine', {}, '')
          .then((value) async {
        return await get(sesion[0]['token'], 'custom', 'carts/mine')
            .then((data) {
          return Respuesta(result: 'ok', data: data, error: null);
        });
      });
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<void> cleanCart(cart) async {
    try {
      final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
      print('**************delete item:*************');
      for (dynamic element in cart) {
        print(element);
        await delete(sesion[0]['token'], 'customer',
            'carts/mine/items/${element['item_id']}');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<Respuesta> addItemInCart(
      id, sku, custom_options, configurable_item_options) async {
    try {
      final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
      Map<String, dynamic> cartItem = {
        "cartItem": {
          "quote_id": id,
          "sku": sku,
          "qty": 1,
          "product_type": "booking",
          "product_option": {
            "extension_attributes": {
              "custom_options": custom_options,
              "configurable_item_options": configurable_item_options
            }
          }
        }
      };

      print('**************cartItem*************');
      print(cartItem);

      final newCart = await post(
          sesion[0]['token'], 'custom', 'carts/mine/items', cartItem, 'v2');

      print('**************newCart*************');
      print(newCart);

      if (newCart.isNotEmpty) {
        return Respuesta(result: 'ok', data: cartItem, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> createBulling(custom_attributes) async {
    try {
      final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
      //Agregamos Bulling y
      Map<String, dynamic> info = {
        "addressInformation": {
          "billing_address": {
            "firstname": sesion[0]['nombre'],
            "lastname": sesion[0]['apellido_paterno'],
            "street": [getCustomAttribute(custom_attributes, 'hotel_address')],
            "country_id": "MX",
            "region": "MX",
            "region_code": "MX",
            "region_id": getCustomAttribute(custom_attributes, 'hotel_state'),
            "city":
                getCustomAttribute(custom_attributes, 'product_city_string'),
            "telephone": sesion[0]['telefono'],
            "postcode": sesion[0]['zip_code'],
            "email": sesion[0]['username'],
          },
          "shipping_address": {
            "firstname": sesion[0]['nombre'],
            "lastname": sesion[0]['apellido_paterno'],
            "street": [getCustomAttribute(custom_attributes, 'hotel_address')],
            "country_id": "MX",
            "region": "MX",
            "region_code": "MX",
            "region_id": getCustomAttribute(custom_attributes, 'hotel_state'),
            "city":
                getCustomAttribute(custom_attributes, 'product_city_string'),
            "telephone": sesion[0]['telefono'],
            "postcode": sesion[0]['zip_code'],
            "email": sesion[0]['username'],
          },
          "shipping_method_code": "",
          "shipping_carrier_code": ""
        }
      };

      final shippingInfo = await post(sesion[0]['token'], 'custom',
          'carts/mine/shipping-information', info, '');

      print('**************shippingInfo*************');
      print(shippingInfo);

      if (shippingInfo.isNotEmpty) {
        return Respuesta(result: 'ok', data: shippingInfo, error: null);
      } else {
        return Respuesta(
            result: 'fail',
            data: {'data': 'La info esta corrupta'},
            error: 'Error: Api');
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> putOrder() async {
    try {
      final sesion = await serviceDB.instance.getById('users', 'id_user', 1);
      final orden = await put(
          sesion[0]['token'],
          'custom',
          'carts/mine/order',
          {
            "paymentMethod": {"method": "checkmo"}
          },
          '');

      print('************* ORDEN: ${orden} *************');
      if (orden.runtimeType != int) {
        return Respuesta(result: 'fail', data: orden, error: null);
      } else {
        return Respuesta(result: 'ok', data: {'id': orden}, error: null);
      }
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }

  Future<Respuesta> createOrder(orden) async {
    try {
      final _cart = await createCart();
      if (_cart.result == 'fail') {
        return _cart;
      }

      //Limpiar los productos
      if (_cart.data!['items'].isNotEmpty) {
        await cleanCart(_cart.data!['items']);
      }

      await addItemInCart(orden['id'], orden['sku'], orden['custom_options'],
          orden['configurable_item_options']);
      await createBulling(orden['custom_attributes']);

      return await putOrder();
    } on Exception catch (e) {
      return Respuesta(
          result: 'fail', data: {'data': 'Error en App'}, error: e.toString());
    }
  }
}

class NetworkError extends Error {}

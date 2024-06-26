import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'package:andromeda/utilities/strings.dart';

import 'package:andromeda/services/db.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

responseErrorWarning(context, String msj) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: msj,
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

responseWarning(context, String msj) {
  return FToast.toast(
    context,
    msg: MyString.forceStop,
    subMsg: msj,
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

responseSuccessWarning(context, String msj) {
  return FToast.toast(
    context,
    msg: MyString.successMsg,
    subMsg: msj,
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

dynamic closeSession(BuildContext context) {
  return PanaraConfirmDialog.showAnimatedFromBottom(context,
      title: MyString.areYouSure,
      message: "Cerraremos tu sesion",
      confirmButtonText: "Si",
      cancelButtonText: "No", onTapCancel: () {
    Navigator.pop(context);
  }, onTapConfirm: () async {
    await serviceDB.instance.cleanAllTable();
    //await serviceDB.instance.deleteDatabase();
    Navigator.pushNamed(context, 'home');
    //Navigator.of(context)
    //    .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
  },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false,
      color: Colors.black,
      textColor: Colors.black,
      buttonTextColor: Colors.white);
}

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isEmpty || !regex.hasMatch(value)
      ? 'Ingresa un correo valido'
      : null;
}

getCustomAttribute(data, type) {
  if (data.length == 0) {
    return '';
  }

  Map<String, String> typeValue = {'product_score': '0'};
  String? value = typeValue[type] ?? '';
  for (dynamic attr in data) {
    if (attr['attribute_code'] == type) {
      value = attr['value'];
    }
  }
  return value;
}

String pathMedia(String media) {
  return "${dotenv.env['PROTOCOL']}://${dotenv.env['URL']}/media/catalog/product$media";
}

/*dynamic deleteFavoritos(BuildContext context, id) {
  return PanaraConfirmDialog.show(
    context,
    title: MyString.areYouSure,
    message: "¿Deseas borrar de tu lista de favoritos",
    confirmButtonText: "Si",
    cancelButtonText: "No",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () async {
      final user = await serviceDB.instance.getById('users', 'id_user', 1);
      if (user.isEmpty) {
        return;
      }
      String token = user[0]['token'];
      await delete(token, 'custom', 'wishlist/customer/item/$id');
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}*/

String translateStatus(String status) {
  const map = {
    'for_serve': 'Por Atender',
    'serving': 'Atendiendo',
    'canceled': 'Cancelada',
    'pending': 'Pendiente',
    'reserved': 'Reservada',
  };
  return map[status] ?? status;
}

dynamic infoAlertModal(BuildContext context, String msj) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: "Info", message: msj, buttonText: "Okay", onTapDismiss: () {
    Navigator.pop(context);
  },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false,
      color: Colors.black,
      textColor: Colors.black,
      buttonTextColor: Colors.white);
}

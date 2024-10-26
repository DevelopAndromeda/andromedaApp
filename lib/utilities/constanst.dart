import 'package:appandromeda/services/customer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:intl/intl.dart';

//import 'package:ftoast/ftoast.dart';
import 'package:toastification/toastification.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'package:appandromeda/utilities/strings.dart';

import 'package:appandromeda/services/db.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appandromeda/blocs/reservations/reservation_bloc.dart';

import 'package:intl/intl.dart';

responseErrorWarning(context, String msj) {
  /*¨return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: msj,
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );*/
  return toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
    title: Text(MyString.oopsMsg),
    description: RichText(text: TextSpan(text: msj)),
    autoCloseDuration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 300),
  );
}

responseWarning(context, String msj) {
  /*return FToast.toast(
    context,
    msg: MyString.forceStop,
    subMsg: msj,
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );*/
  return toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: ToastificationType.warning,
    style: ToastificationStyle.fillColored,
    title: Text(MyString.forceStop),
    description: RichText(text: TextSpan(text: msj)),
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
  );
}

responseSuccessWarning(context, String msj) {
  /*return FToast.toast(
    context,
    msg: MyString.successMsg,
    subMsg: msj,
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );*/
  return toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: Text(MyString.successMsg),
    description: RichText(text: TextSpan(text: msj)),
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
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
    Navigator.pop(context);
    //await serviceDB.instance.deleteDatabase();
    Navigator.pushNamed(context, 'home');
  },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: true,
      color: Colors.black,
      textColor: Colors.black,
      buttonTextColor: Colors.white);
}

dynamic deleteAccount(BuildContext context) {
  return PanaraConfirmDialog.showAnimatedFromBottom(context,
      title: MyString.areYouSure,
      message: "Ten en cuenta que tu cuenta sera borrada, confirmar",
      confirmButtonText: "Si",
      cancelButtonText: "No", onTapCancel: () {
    Navigator.pop(context);
  }, onTapConfirm: () async {
    Navigator.pop(context);
    await CustomerService().deleteAccount().then((value) async {
      if (value.result == 'ok') {
        await serviceDB.instance.cleanAllTable();
        responseSuccessWarning(context, 'Tu cuenta fue borrada Exitosamente!');
        Navigator.pushNamed(context, 'home');
      }
    });
  },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: true,
      color: Colors.black,
      textColor: Colors.black,
      buttonTextColor: Colors.white);
}

dynamic closeReservation(BuildContext context, entity_id, label) {
  PanaraConfirmDialog.showAnimatedFromBottom(context,
      title: MyString.areYouSure,
      message: "¿Deseas cerrar la reservacion?",
      confirmButtonText: "Si",
      cancelButtonText: "No", onTapCancel: () {
    Navigator.pop(context);
  }, onTapConfirm: () async {
    ReservationBloc()..add(ChangeStatusReservation(entity_id, label));
    Navigator.pop(context);
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

whitAvatar(String img) {
  try {
    if (img.length > 65535) {
      return Image.memory(base64Decode(img.replaceAll(RegExp(r'\s+'), '')))
          .image;
    } else {
      return Image.memory(base64Decode(img)).image;
    }
  } catch (e) {
    return Image.asset('assets/Profile.png');
  }

  //
  //return Image.memory(base64Decode(img)).image;
}

String translateStatus(String status) {
  const map = {
    'new': 'Nuevo',
    'for_serve': 'Por Atender',
    'serving': 'Atendiendo',
    'canceled': 'Cancelada',
    'cancel': 'Cancelada',
    'pending': 'Pendiente',
    'reserved': 'Reservada',
  };
  return map[status] ?? status;
}

Color transformColor(String status) {
  const map = {
    'new': Color.fromARGB(255, 74, 162, 104),
    'for_serve': Color.fromARGB(255, 207, 176, 2),
    'serving': Color.fromARGB(255, 207, 176, 2),
    'canceled': Color.fromARGB(255, 241, 58, 45),
    'cancel': Color.fromARGB(255, 241, 58, 45),
    'pending': Color.fromARGB(255, 207, 176, 2),
    'reserved': Color.fromARGB(255, 46, 17, 238),
    'complete': Color.fromARGB(255, 46, 17, 238)
  };
  return map[status] ?? const Color.fromARGB(255, 207, 176, 2);
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

String transformPrice(price) {
  String cadena = r'$';
  double valorFinal = double.parse(price);

  if (price == '') {
    return cadena;
  }

  if (valorFinal >= 251 && valorFinal <= 500) {
    cadena = r'$$';
  } else if (valorFinal >= 501 && valorFinal <= 750) {
    cadena = r'$$$';
  } else if (valorFinal > 750) {
    cadena = r'$$$$';
  }

  return cadena;
}

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

const dividerLine = const Divider(
  color: Colors.black,
  thickness: 1,
);

bool esHoraMayor(String hora12) {
  try {
    // Obtener la hora actual
    DateTime ahora = DateTime.now();

    // Parsear la hora en formato de 12 horas
    DateFormat formato12 = DateFormat("hh:mm a");
    DateTime horaIngresada = formato12.parse(hora12.toUpperCase());

    //print(horaIngresada.isAfter(ahora));

    // Comparar las horas
    return horaIngresada.isAfter(ahora);
  } catch (e) {
    // Manejo de excepciones
    print('Error al parsear la hora: $e');
    return false; // Retorna false si hay un error
  }
}

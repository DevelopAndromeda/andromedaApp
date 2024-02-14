import 'package:flutter/material.dart';
import 'package:andromeda/Witgets/Notifications/Successful_Notification_.dart';
import 'package:andromeda/Witgets/Notifications/Reservation_Notificacion.dart';

class MyNotificationsPage extends StatefulWidget {
  const MyNotificationsPage({super.key});

  @override
  State<MyNotificationsPage> createState() => _MyNotificationsPageState();
}

class _MyNotificationsPageState extends State<MyNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return //Confirmación de reservación
       ReservationNotification(
        title: "Confirmacion de tu reservación", 
        subtitle: "Nombre del Restaurante", 
        description: "Datos de la reservación", 
        imagePath: "assets/ExampleRest.png", 
        onClose: (){
          print("Notificaciones");
        },
        );
  }
/*
    return //Notificacion de cancelacion de la reservación
       CancellationNotification(
        title: "Cancelacion de Reservación", 
        subtitle: "Nombre del Restaurante", 
        description: "Datos de la reservación", 
        imagePath: "assets/ExampleRest.png", 
        onClose: (){
          print("Notificaciones");
        },
        );
  }
*/
/*
  return //Notificacion de reservación modificada por alguna de las 2 partes, restaurante o usuario
       ModificationNotification(
        title: "Modificacion de la reservación", 
        subtitle: "Nombre del Restaurante", 
        description: "Datos de la reservación", 
        imagePath: "assets/ExampleRest.png", 
        onClose: (){
          print("Notificaciones");
        },
        );
  }
*/
/*
  return //Confirmación de reservación
       SuccessfullNotification(
        title: "Tu reservación a sido realizada", 
        subtitle: "Nombre del Restaurante", 
        description: "Datos de la reservación", 
        imagePath: "assets/ExampleRest.png", 
        onClose: (){
          print("Notificaciones");
        },
        );
  }
*/
  //Pendiente a resolver con Emma :x
  //Crear validaciones y formatos de para mandar a llamar las funciones 
}

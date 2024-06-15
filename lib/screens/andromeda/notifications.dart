import 'package:flutter/material.dart';
import 'package:andromeda/witgets/notifications/reservation_notificacion.dart';

class MyNotificationsPage extends StatefulWidget {
  const MyNotificationsPage({super.key});

  @override
  State<MyNotificationsPage> createState() => _MyNotificationsPageState();
}

class _MyNotificationsPageState extends State<MyNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: ReservationNotification(
            title: "Confirmacion de tu reservación",
            subtitle: "Nombre del Restaurante",
            description: "Datos de la reservación",
            imagePath: "assets/Login.png",
            onClose: () {
              //print("Notificaciones");
            },
          ),
        ),
      ),
      /*bottomNavigationBar: const MyBottomBar(
        index: 4,
      ),*/
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

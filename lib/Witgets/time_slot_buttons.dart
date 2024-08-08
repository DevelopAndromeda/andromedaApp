import 'package:flutter/material.dart';

class TimeSlotButton extends StatelessWidget {
  final double anchoButton;
  final double altoButton;
  final double sizeText;
  final List<String> horas;
  final Map<dynamic, dynamic> data;
  const TimeSlotButton(
      {super.key,
      required this.anchoButton,
      required this.altoButton,
      required this.sizeText,
      required this.horas,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: listSlot());
  }

  listSlot() {
    List<Widget> dataSlot = [];
    int index = 0;
    for (var element in horas) {
      if (index == 3) {
        break;
      }
      dataSlot.add(ButtonSlot(
        hour: element,
        anchoButton: anchoButton,
        altoButton: altoButton,
        sizeText: sizeText,
        data: data,
      ));
      index++;
    }
    return dataSlot;
    /*for(String item in data) {

    }
    return <Widget>[
      ButtonSlot(
          hour: "10:30",
          anchoButton: anchoButton,
          altoButton: altoButton,
          sizeText: sizeText),
      ButtonSlot(
          hour: "11:00",
          anchoButton: anchoButton,
          altoButton: altoButton,
          sizeText: sizeText),
      ButtonSlot(
          hour: "11:30",
          anchoButton: anchoButton,
          altoButton: altoButton,
          sizeText: sizeText)
    ];*/
  }
}

class ButtonSlot extends StatelessWidget {
  final String hour;
  final double anchoButton;
  final double altoButton;
  final double sizeText;
  final Map<dynamic, dynamic> data;
  const ButtonSlot(
      {super.key,
      required this.hour,
      required this.anchoButton,
      required this.altoButton,
      required this.sizeText,
      required this.data});
  //const UsersReviewCard({Key? key}) : super(key: key, required this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          minimumSize: Size(anchoButton, altoButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Redondeo de 10.0
          ),
        ),
        onPressed: () {
          // Respond to button press
          Navigator.pushNamed(context, 'detail', arguments: data);
        },
        child: Text(
          hour,
          style: TextStyle(
            fontSize: sizeText,
            color: Colors.white, // Color del texto
          ),
        ),
      ),
    );
  }
}

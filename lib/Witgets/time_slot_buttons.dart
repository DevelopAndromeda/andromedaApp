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
    /*return Container(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: listSlot(),
      ),
    );*/
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
      //dataSlot.add(Text("tempo"));
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'detail', arguments: data);
            },
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Borde cuadrado
                ),
                padding: const EdgeInsets.all(8),
                backgroundColor: Colors.black),
            child: Text(
              hour,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DropdownItem {
  final int value;
  final String label;

  DropdownItem({required this.value, required this.label});
}

final List<DropdownItem> peopleList = [
  DropdownItem(value: 1, label: '1 persona'),
  DropdownItem(value: 2, label: '2 personas'),
  DropdownItem(value: 3, label: '3 personas'),
  DropdownItem(value: 4, label: '4 personas'),
  DropdownItem(value: 5, label: '5 personas'),
  DropdownItem(value: 6, label: '6 personas'),
  DropdownItem(value: 7, label: '7 personas'),
  DropdownItem(value: 8, label: '8 personas'),
  DropdownItem(value: 9, label: '9 personas'),
  DropdownItem(value: 10, label: '10 personas'),
  DropdownItem(value: 11, label: '11 personas'),
  DropdownItem(value: 12, label: '12 personas'),
  DropdownItem(value: 13, label: '13 personas'),
  DropdownItem(value: 14, label: '14 personas'),
  DropdownItem(value: 15, label: '15 personas'),
  DropdownItem(value: 16, label: '16 personas'),
  DropdownItem(value: 17, label: '17 personas'),
  DropdownItem(value: 18, label: '18 personas'),
  DropdownItem(value: 19, label: '19 personas'),
  DropdownItem(value: 20, label: '20 personas'),
];

class MakeAReservationForm extends StatefulWidget {
  final Future<void> Function(DateTime, int) createReservation;
  const MakeAReservationForm({Key? key, required this.createReservation})
      : super(key: key);
  @override
  MakeAReservationFormState createState() {
    return MakeAReservationFormState();
  }
}

class MakeAReservationFormState extends State<MakeAReservationForm> {
  final _formKey = GlobalKey<FormState>();
  int people = 2;

  DateTime _selectedDate = DateTime.now();
  final Map _slot = {};
  List<dynamic> _slotDay = [];
  List<dynamic> _allSlotDay = [];
  TimeOfDay? selectedTime = TimeOfDay.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                    onPrimary: Color.fromARGB(
                        255, 255, 255, 255), // selected text color
                    onSurface: Color.fromARGB(
                        255, 255, 255, 255), // default text color
                    primary: Color.fromARGB(99, 255, 255, 255) // circle color
                    ),
                dialogBackgroundColor: Colors.black54,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            fontFamily: 'Quicksand'),
                        backgroundColor: Colors.black54, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    print('_slot');
    print(_slot);
    _slot.forEach((key, value) {
      if (int.parse(key) == picked?.weekday) {
        _slotDay = value;
        return;
      }
    });
    _allSlotDay = [];
    for (var e in _slotDay) {
      if (e['slots_info'].runtimeType == List) {
        _allSlotDay.addAll(e['slots_info']);
      } else {
        _allSlotDay.addAll(e['slots_info'].values);
      }
    }
    print(_allSlotDay);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        color: Theme.of(context).dialogBackgroundColor,
        elevation: 4, // La elevación determina la sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Haz una reservación',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<int>(
                  value: people,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      people = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tamaño',
                  ),
                  items: peopleList.map((DropdownItem item) {
                    return DropdownMenuItem<int>(
                      value: item.value,
                      child: Text(item.label),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          child: ListTile(
                            title: const Text('Fecha'),
                            subtitle: Text(
                                DateFormat('yyyy-MM-dd').format(_selectedDate)),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButtonFormField<String>(
                            onChanged: (val) {},
                            items: _allSlotDay
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.exit_to_app,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(e)
                                        ],
                                      ),
                                    ))
                                .toList()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.createReservation(
                            combineDateAndTime(_selectedDate, selectedTime!),
                            people);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        )),
                    child: const Text(
                      'Reservar ahora',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

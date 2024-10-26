import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/inicio/user/user_bloc.dart';
import '../../../blocs/generate_orden/orden_cubit.dart';

import '../../../models/categorias.dart';
import '../../../utilities/constanst.dart';
import '../../../utilities/strings.dart';
import '../../../services/order.dart';
import '../../../witgets/boton_base.dart';

class FormularioOrden extends StatefulWidget {
  const FormularioOrden(
      {super.key,
      required this.sku,
      required this.id,
      required this.custom_attributes
      //required this.long,
      //required this.data
      });

  final String sku, id;
  //final double lat, long;
  final List<dynamic> custom_attributes;

  //final List<dynamic> data;

  @override
  State<FormularioOrden> createState() => _FormularioOrdenState();
}

class _FormularioOrdenState extends State<FormularioOrden> {
  final UserBloc _userBloc = UserBloc();
  final OrderService _orderService = OrderService();

  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _personasController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  List<Categoria> arraySlot = [];
  Categoria? _selectedSlot;
  List _options = [];
  List<dynamic> _slotDay = [];
  late Map<String, dynamic> _slot;
  List<Categoria> zonasList = [];
  Categoria? _selectedZone;
  List<Categoria> tiposMesasList = [];
  Categoria? _selectedTipoMesa;

  bool showNotes = false;

  @override
  void initState() {
    _userBloc.add(GetUser());
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    print("************getSlot: ${widget.id}************");
    await _orderService.getSlot(widget.id).then((slot) {
      if (slot.result == 'ok') {
        _slot = slot.data!['data'];
      } else {
        print(
            'Ocurro un error al obtener informacion de _orderService.getSlot');
      }
    });

    print("************getOptions: ${widget.sku}************");
    await _orderService.getOptions(widget.sku).then((options) {
      if (options.result == 'ok') {
        _options = options.data!['data'];

        for (dynamic data in _options) {
          if (data['title'] == 'Zona') {
            for (dynamic item in data['values']) {
              zonasList.add(
                  Categoria(id: item['option_type_id'], name: item['title']));
            }
          }

          if (data['title'] == 'Tipo de Mesa') {
            for (dynamic item in data['values']) {
              tiposMesasList.add(
                  Categoria(id: item['option_type_id'], name: item['title']));
            }
          }

          if (data['title'] == 'Special Request/Notes') {
            showNotes = true;
          }
        }
      } else {
        print(
            'Ocurro un error al obtener informacion de _orderService.getOptions');
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocProvider(
        create: (_) => _userBloc,
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            /*if (state is UserError) {
                          responseErrorWarning(context, state.message!);
                        }*/
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return Form(
                  key: _formKey,
                  child: Card(
                    color: Theme.of(context).dialogBackgroundColor,
                    elevation: 4, // La elevación determina la sombra
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
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
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          dividerLine,
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey)),
                              ),
                              child: ListTile(
                                title: const Text('Fecha'),
                                subtitle: Text(DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate)),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(context),
                              ),
                            ),
                          ),
                          arraySlot.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownButtonFormField<Categoria>(
                                    icon: const Icon(Icons.arrow_downward),
                                    value: _selectedSlot,
                                    onChanged: (Categoria? value) {
                                      setState(() {
                                        print(value);
                                        _selectedSlot = value;
                                        //slot_id = val!;
                                        //Hora = _allSlotDayString[val];
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Horario',
                                    ),
                                    items: arraySlot
                                        .map<DropdownMenuItem<Categoria>>(
                                            (Categoria value) {
                                      return DropdownMenuItem<Categoria>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                          zonasList.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownButtonFormField<Categoria>(
                                    icon: const Icon(Icons.arrow_downward),
                                    value: _selectedZone,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (Categoria? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        _selectedZone = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Zona',
                                    ),
                                    items: zonasList
                                        .map<DropdownMenuItem<Categoria>>(
                                            (Categoria value) {
                                      return DropdownMenuItem<Categoria>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                          tiposMesasList.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownButtonFormField<Categoria>(
                                    value: _selectedTipoMesa,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (Categoria? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        _selectedTipoMesa = value!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Tipo de mesa',
                                    ),
                                    items: tiposMesasList
                                        .map<DropdownMenuItem<Categoria>>(
                                            (Categoria value) {
                                      return DropdownMenuItem<Categoria>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                          cantPersonInput(),
                          const SizedBox(height: 12.0),
                          showNotes ? descriptionInput() : const SizedBox(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 5),
                            child: Center(
                              child: MyBaseButtom(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_selectedSlot == null) {
                                      responseErrorWarning(context,
                                          "Selecciona un horario por favor!");
                                      return;
                                    }

                                    List<Map<String, dynamic>> custom_options =
                                        [];
                                    for (dynamic item in _options) {
                                      String value = '';
                                      if (item['title'] == 'Booking Date') {
                                        value = DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate)
                                            .toString();
                                      }

                                      if (item['title'] == 'Booking Slot') {
                                        value = _selectedSlot!.name;
                                      }

                                      if (item['title'] ==
                                          'Special Request/Notes') {
                                        value = _descripcionController.text;
                                      }

                                      if (item['title'] == 'Charged Per') {
                                        value = _personasController.text;
                                      }

                                      if (item['title'] == 'Zona') {
                                        value = _selectedZone!.id.toString();
                                      }

                                      if (item['title'] == 'Tipo de Mesa') {
                                        value =
                                            _selectedTipoMesa!.id.toString();
                                      }

                                      custom_options.add({
                                        "option_id": item['option_id'],
                                        "option_value": value
                                      });
                                    }

                                    custom_options.add({
                                      "option_id": "booking_date",
                                      "option_value": DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate)
                                          .toString()
                                    });
                                    custom_options.add({
                                      "option_id": "booking_time",
                                      "option_value": _selectedSlot!.name
                                    });

                                    List<Map<String, dynamic>>
                                        configurable_item_options = [];
                                    configurable_item_options.addAll([
                                      {
                                        "option_id": "product",
                                        "option_value": widget.id
                                      },
                                      {
                                        "option_id": "item",
                                        "option_value": widget.id
                                      },
                                      {
                                        "option_id":
                                            "selected_configurable_option",
                                        "option_value": "0"
                                      },
                                      {
                                        "option_id": "related_product",
                                        "option_value": "0"
                                      },
                                      {
                                        "option_id": "parent_slot_id",
                                        "option_value": 0
                                      },
                                      {
                                        "option_id": "slot_id",
                                        "option_value": _selectedSlot!.id
                                      },
                                      {
                                        "option_id": "slot_day_index",
                                        "option_value": _selectedDate.weekday
                                      },
                                      {
                                        "option_id": "charged_per_count",
                                        "option_value": 4
                                      },
                                      {
                                        "option_id": "temp_qty",
                                        "option_value": _personasController.text
                                      }
                                    ]);

                                    print(
                                        "****************configurable_item_options****************");
                                    print(configurable_item_options);

                                    Map<String, dynamic> orden = {
                                      "id": widget.id,
                                      "sku": widget.sku,
                                      "custom_options": custom_options,
                                      "configurable_item_options":
                                          configurable_item_options,
                                      "custom_attributes":
                                          widget.custom_attributes
                                    };
                                    context
                                        .read<OrdenLogic>()
                                        .generateOrderLogic(orden, context);
                                  } else {
                                    responseErrorWarning(
                                        context, MyString.required);
                                    return;
                                  }
                                },
                                text: BlocBuilder<OrdenLogic, OrdenState>(
                                    builder: (context, state) {
                                  if (state is OrdenLoadingState) {
                                    return state.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text("Reservar ahora",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white));
                                  } else {
                                    return const Text(
                                      "Reservar ahora",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    );
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: MyBaseButtom(
                    onPressed: () => Navigator.pushNamed(context, 'login'),
                    text: const Text(
                      "Iniciar Sesion",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        //initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                  onPrimary:
                      Color.fromARGB(255, 255, 255, 255), // selected text color
                  onSurface:
                      Color.fromARGB(255, 255, 255, 255), // default text color
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
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        });

    arraySlot = [];
    _selectedSlot = null;
    // Obtener la hora actual
    DateTime fechaActual = DateTime.now();

    //print('**********uno***********');
    //print(picked?.weekday.toString());

    //print('**********dos***********');
    //print(_slot.toString());

    //Posible boton de cancelado
    if (picked?.weekday == null) {
      return;
    }

    _slotDay = _slot[picked?.weekday.toString()];

    //print('**********tres***********');
    //print();
    //print(picked?.weekday);
    //print(fechaActual.weekday);

    for (var e in _slotDay) {
      if (e['slots_info'].runtimeType == List) {
        int indice = 0;
        for (var j in e['slots_info']) {
          if (picked?.weekday == fechaActual.weekday) {
            //print(j['time']);
            if (esHoraMayor(j['time'])) {
              arraySlot.add(Categoria(id: indice, name: j['time']));
            }
          } else {
            arraySlot.add(Categoria(id: indice, name: j['time']));
          }

          //arraySlot.add({'key': indice, 'value': j['time']});
          //arraySlot.add(DropdownItem(value: indice, label: j['time']));
          //_allSlotDayString.add(j['time']);
          indice++;
        }
      }
    }

    if (picked != null && picked != _selectedDate) {
      if (arraySlot.isEmpty) {
        // Formatear la hora en formato de 12 horas
        String horaFormateada = DateFormat.jm().format(fechaActual);

        responseErrorWarning(
            context, "No se encontraro horarios posteriores a $horaFormateada");
      }
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Container descriptionInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _descripcionController,
          maxLines: 4,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Notas adicionales',
              style: TextStyle(color: Colors.grey),
            ),
            //suffixIcon: const Icon(Icons.document_scanner),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese el descripcion del restaurante';
            }
            return null;
          },*/
        ));
  }

  Container cantPersonInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: _personasController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: OutlineInputBorder(
              // Esto es opcional, pero recomendado
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                color: Colors.black, // Borde predeterminado en negro
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Cantidad de Comensales',
              style: TextStyle(color: Colors.grey),
            ),
            //suffixIcon: const Icon(Icons.document_scanner),
            ///////
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0), // Borde negro cuando está habilitado
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Borde negro más grueso cuando está enfocado
            ),
          ),
          style: const TextStyle(color: Colors.black), // Texto negro
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese cantidad de comensales';
            }
            return null;
          },
        ));
  }
}

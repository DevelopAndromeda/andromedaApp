import 'package:appandromeda/utilities/constanst.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/blocs/orden/orden_bloc.dart';

import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/witgets/skeleton.dart';

import 'package:appandromeda/witgets/Colores_Base.dart';
import 'package:intl/intl.dart';

class MyOrdenScreen extends StatefulWidget {
  final int id;
  const MyOrdenScreen({super.key, required this.id});

  @override
  _MyOrdenScreenState createState() => _MyOrdenScreenState();
}

class _MyOrdenScreenState extends State<MyOrdenScreen> {
  late final OrdenBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = OrdenBloc();
    _orderBloc.add(GetOrdenByEntityId(widget.id));
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background_Color,
      appBar: AppBar(
        title: const Text(
          'Reservacion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, 'home'),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _body(),
    );
  }

  Container _body() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _orderBloc,
        child: BlocListener<OrdenBloc, OrdenState>(
          listener: (context, state) {
            /*if (state is FavoriteError) {
              responseErrorWarning(context, state.message!);
            }*/
          },
          child: BlocBuilder<OrdenBloc, OrdenState>(
            builder: (context, state) {
              if (state is OrdenInitial) {
                return const Skeleton(cantData: 4);
              } else if (state is OrdenLoading) {
                return const Skeleton(cantData: 4);
              } else if (state is OrdenLoaded) {
                return _buildCard(context, state.data);
              } /*else if (state is FavoriteError) {
                return const WrongConnection();
              } */
              else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Respuesta model) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Reservación n.° ${model.data?['increment_id']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      translateStatus(model.data?['status']),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      model.data?['created_at'],
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Reservaciones",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    _dividerLine,
                    tr(model),
                    const SizedBox(height: 10),
                    _dividerLine,
                    const Text(
                      "Información de reservación",
                      style: TextStyle(fontSize: 16),
                    ),
                    trShipping(model)
                  ]),
            )
          ],
        ),
      ),
    );
  }

  final _dividerLine = const Divider(
    color: Colors.black,
    thickness: 1,
  );

  Column tr(model) {
    return Column(
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
              child: Text("RESTAURANTE",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Flexible(
              child: Text("SKU",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Flexible(
              child: Text("CANT",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        ]),
        _dividerLine,
        model.data['items'].isNotEmpty
            ? SingleChildScrollView(
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: model.data['items'].length,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(model.data['items'][index]['name'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    const Text("Fecha de reserva",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(model.data['items'][index]
                                                ['product_option']
                                            ['extension_attributes']
                                        ['custom_options'][0]['option_value']),
                                    const SizedBox(height: 5),
                                    const Text("Hora de reserva",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(model.data['items'][index]
                                                ['product_option']
                                            ['extension_attributes']
                                        ['custom_options'][1]['option_value']),
                                    const SizedBox(height: 5),
                                    const Text("Notas adicionales",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(model.data['items'][index]
                                                ['product_option']
                                            ['extension_attributes']
                                        ['custom_options'][2]['option_value']),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Text(model.data['items'][index]['sku'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Flexible(
                                  child: Text(
                                      "Ordenado: ${model.data['items'][index]['qty_ordered']}")),
                            ]);
                      }),
                ),
              )
            : Container(),
        _dividerLine,
        Row(
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 140, right: 40),
                child: Column(
                  children: [
                    Text("Total Parcial"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Gran Total",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Text(r"$"
                        "${NumberFormat("###.00", "en_US").format(model.data['subtotal'])}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        r"$"
                        "${NumberFormat("###.00", "en_US").format(model.data['grand_total'])}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))
                  ],
                ))
          ],
        )
      ],
    );
  }

  Column trShipping(model) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
              child: Text("Direccion de Envio",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          Flexible(
              child: Text("Metodo de pago",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
              child: Column(
            children: [
              Text(
                  "${model.data?['customer_firstname']} ${model.data?['customer_lastname']}",
                  style: const TextStyle(fontSize: 14)),
              /*model.data?['billing_address']['street'].isNotEmpty
                  ? ListView.builder(
                      itemCount:
                          model.data?['billing_address']['street'].length,
                      itemBuilder: (context, index) {
                        return Text(
                            "${model.data?['billing_address']['street'][index]}",
                            style: const TextStyle(fontSize: 14));
                      })
                  : Container(),*/
              Text(
                  "${model.data?['billing_address']['city']}, ${model.data?['billing_address']['region']}, ${model.data?['billing_address']['postcode']}, México",
                  style: const TextStyle(fontSize: 14)),
              Text("T: ${model.data?['billing_address']['telephone']}",
                  style: const TextStyle(fontSize: 14))
            ],
          )),
          const Flexible(child: Text("Confirmar Reservacion")),
        ])
      ],
    );
  }
}
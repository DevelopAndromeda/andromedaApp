import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:andromeda/Witgets/Button_Base.dart';

import 'package:andromeda/services/api.dart';
import 'package:andromeda/services/db.dart';

import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:andromeda/models/codigospostales.dart';
import 'package:andromeda/models/categorias.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key, required this.type});
  final int type;

  @override
  _MyRegisterContet createState() => _MyRegisterContet();
}

class _MyRegisterContet extends State<MyRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  //Rest Extra inputs
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool typePassword = true;
  bool typePasswordConfirm = true;
  bool _isButtonDisabled = false;
  String selectedGender = '';
  String? _searchingWithQuery;

  late Future<List<Pais>>? futurePais;
  Pais? _selectedPais = null;

  Future<List<Estado>>? futureEstado;
  Estado? _selectedEstado;

  Future<List<Ciudad>>? futureCiudad;
  Ciudad? _selectedCiudad;

  List<CodigoPostal>? futureCodigosPostales = <CodigoPostal>[];
  //late Future<List<Pais>>? futureCodigosPostales;
  //late Iterable<String> _lastOptions = <String>[];
  List<CodigoPostal> _lastOptions = <CodigoPostal>[];
  CodigoPostal? _selectedCodigoPostal;

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  String? validatePasswords() {
    return _passwordController.text != _confirmPasswordController.text
        ? 'Las contraseñas no coinciden'
        : null;
  }

  Future<List<Pais>> fetchPaises() async {
    final responseJson = json.decode("""
    {
      "data": [
        {
          "id": "1",
          "name": "México",
          "code": "MX"
        }
      ]
    }
    """);

    return (responseJson['data'] as List)
        .map((data) => Pais.fromJson(data))
        .toList();
  }

  Future<List<Estado>> fetchEstados() async {
    //Llenar base de datos local
    final responseJson =
        await get('', '', 'states?countryCode=${_selectedPais?.code}');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Estado.fromJson(data))
        .toList();
  }

  Future<List<Ciudad>> fetchCiudades() async {
    final responseJson = await get(
        '', 'integration', 'product/cities?search=${_selectedEstado?.code}');
    if (responseJson == null) {
      //print('no hay datos en endpoint');
      return [];
    }

    return (responseJson['items'] as List)
        .map((data) => Ciudad.fromJson(data))
        .toList();
  }

  Future<List<CodigoPostal>> fetchCodigosPostales(String code) async {
    String url =
        "threedadv-sepomex/zip_code_full_wiew/search?searchCriteria[filterGroups][0][filters][1][field]=codigo_postal&searchCriteria[filterGroups][0][filters][1][value]=$code&searchCriteria[filterGroups][0][filters][1][conditionType]=eq&searchCriteria[currentPage]=1&searchCriteria[pageSize]=20";
    if (_selectedCiudad != null) {
      print(_selectedCiudad);
      url =
          "$url&searchCriteria[filterGroups][1][filters][0][field]=nombre_estado&searchCriteria[filterGroups][1][filters][0][value]=${_selectedEstado?.label}&searchCriteria[filterGroups][1][filters][0][conditionType]=eq";
    }
    final responseJson = await get('', 'integration', url);
    return (responseJson['items'] as List)
        .map((data) => CodigoPostal.fromJson(data))
        .toList();
  }

  //List<String> dropdownItems = <String>[];

  /*List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: widget.type == 0 ? "Comensal" : "Restaurante", child: Text("Comensal"))
    ];
    return menuItems;
  }*/

  //String? selectedValue;

  @override
  void initState() {
    super.initState();
    futurePais = fetchPaises();
    //dropdownItems.add(widget.type == 0 ? "Comensal" : "Restaurante");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          widget.type == 0 ? 'Comensal' : 'Restaurantero',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 1,
      ),
      body: SingleChildScrollView(
          child: widget.type == 0 ? clietForm() : restForm()),
    );
  }

  /*Form(
          key: _formKey,
          child: Column(
            children: [
              ClipPath(
                child: Container(
                  width: 450,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/Login.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Positioned(
                  bottom: 0,
                  left: 10,
                  right: 0,
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      'Recomendacion del mes, Black food - Roma CDMX                         ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 20, // Altura del separador
                color:
                    Color.fromARGB(255, 255, 255, 255), // Color del separador
                thickness: 2, // Grosor del separador
                indent: 20, // Espaciado izquierdo del separador
                endIndent: 20, // Espaciado derecho del separador
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/LogoWhite.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(
                height: 1, // Altura del separador
                color:
                    Color.fromARGB(255, 255, 255, 255), // Color del separador
                thickness: 2, // Grosor del separador
                indent: 20, // Espaciado izquierdo del separador
                endIndent: 20, // Espaciado derecho del separador
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _firstController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Nombre',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _lastController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Apellido',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu apellido';
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      label: const Text(
                        'Correo',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }

                      String? isValid = validateEmail(value);
                      if (isValid != null) {
                        return isValid;
                      }

                      return null;
                    }),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: typePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    label: const Text(
                      'Contraseña',
                      style: TextStyle(color: Colors.grey),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          typePassword = !typePassword;
                        });
                      },
                      child: Icon(typePassword == true
                          ? Icons.lock_clock_outlined
                          : Icons.lock_open_sharp),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }

                    String? isValid = validatePasswords();
                    if (isValid != null) {
                      return isValid;
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: typePasswordConfirm,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    label: const Text(
                      'Confirmar contraseña',
                      style: TextStyle(color: Colors.grey),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          typePasswordConfirm = !typePasswordConfirm;
                        });
                      },
                      child: Icon(typePasswordConfirm == true
                          ? Icons.lock_outline
                          : Icons.lock_open),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }

                    String? isValid = validatePasswords();
                    if (isValid != null) {
                      return isValid;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Seleccione su género:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () => selectGender('Masculino'),
                          icon: Icon(
                            Icons.male,
                            color: selectedGender == 'Masculino'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          label: Text(
                            'Masculino',
                            style: TextStyle(
                              color: selectedGender == 'Femenino'
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGender == 'Masculino'
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            shadowColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => selectGender('Femenino'),
                          icon: Icon(
                            Icons.female,
                            color: selectedGender == 'Femenino'
                                ? Colors.pink
                                : Colors.grey,
                          ),
                          label: Text(
                            'Femenino',
                            style: TextStyle(
                              color: selectedGender == 'Femenino'
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGender == 'female'
                                ? Colors.pink.shade100
                                : Colors.grey.shade200,
                            shadowColor: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Género seleccionado: $selectedGender',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                // width: double.maxFinite,
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: baseButtom(
                  text: 'Registrarse',
                  onPressed: _isButtonDisabled
                      ? () {}
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              //Llamada a endpoint
                              final registro = await post(
                                  '',
                                  'admin',
                                  'customers',
                                  {
                                    'customer': {
                                      'email': _emailController.text,
                                      'firstname': _firstController.text,
                                      'lastname': _lastController.text,
                                      "group_id": widget.type == 0 ? 5 : 4,
                                    },
                                    'password': _passwordController.text
                                  },
                                  '');

                              //print('registro');

                              if (registro == null) {
                                //print('hay error');
                                //print(registro);
                                //ScaffoldMessenger.of(context).showSnackBar(
                                //    SnackBar(
                                //        content: Text(registro['message'])));
                                setState(() {
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                return;
                              }

                              /*if (registro["message"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(registro["message"])));
                          return;
                        }*/

                              //Creamos mapa para guardar en base de datos local
                              Map<String, dynamic> data = {
                                'id_user': 1,
                                'id': registro['id'],
                                'nombre': _firstController.text,
                                'apellido_paterno': _lastController.text,
                                'username': _emailController.text,
                                'password': _passwordController.text,
                                'group_id': registro['group_id']
                              };

                              //print(data);
                              //print('data');

                              final login = await post(
                                  '',
                                  '',
                                  'integration/customer/token',
                                  {
                                    'username': _emailController.text,
                                    'password': _passwordController.text
                                  },
                                  '');

                              //Revision de respuesta
                              if (login.runtimeType != String) {
                                //print('hay error');
                                //print(login['message']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(login['message'])));
                                setState(() {
                                  _isButtonDisabled = !_isButtonDisabled;
                                });
                                return;
                              }

                              //print(login);

                              if (widget.type == 1 &&
                                  registro['group_id'] == 5) {
                                final update = await put(
                                    login, 'custom', 'customergroup/', {}, '4');

                                //print(update);

                                if (update != null) {
                                  data['group_id'] =
                                      update['data']['new_group_id'];
                                }
                              }

                              final user = await serviceDB.instance
                                  .getById('users', 'id_user', 1);
                              //print('usuario');
                              //print(user);
                              //Si existen datos en base de datos local actualizamos datos en mapa
                              if (user.isNotEmpty) {
                                await serviceDB.instance
                                    .updateRecord('users', data, 'id_user', 1);
                              } else {
                                //Si no existen datos en base de datos local insertamos datos en mapa
                                data['id_user'] = 1;
                                await serviceDB.instance
                                    .insertRecord('users', data);
                              }

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  widget.type == 0 ? 'home' : 'home-rest',
                                  (Route<dynamic> route) => false);
                            } catch (e) {
                              setState(() {
                                _isButtonDisabled = !_isButtonDisabled;
                              });
                              //print(e);
                            }
                          }
                        },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),*/

  Form restForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          crearPortada(),
          crearPublicidad(),
          _divider(),
          logo(),
          _divider(),
          const SizedBox(height: 20),
          nameInput(),
          const SizedBox(height: 10),
          lastInput(),
          const SizedBox(height: 10),
          emailInput(),
          const SizedBox(height: 10),
          passwordInput(),
          const SizedBox(height: 10),
          confirPassworInput(),
          const SizedBox(height: 10),
          rfcInput(),
          const SizedBox(height: 10),
          razonSocial(),
          const SizedBox(height: 10),
          generoBoxButton(),
          buttonSendInfo()
        ],
      ),
    );
  }

  Form clietForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          crearPortada(),
          crearPublicidad(),
          _divider(),
          logo(),
          _divider(),
          const SizedBox(height: 20),
          nameInput(),
          const SizedBox(height: 10),
          lastInput(),
          const SizedBox(height: 10),
          emailInput(),
          const SizedBox(height: 10),
          passwordInput(),
          const SizedBox(height: 10),
          confirPassworInput(),
          const SizedBox(height: 10),
          telefonoInput(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: paisSelect()),
              Expanded(child: estadoSelect()),
            ],
          ),
          const SizedBox(height: 10),
          ciudadSelect(),
          const SizedBox(height: 10),
          codigoPostalSelect(),
          const SizedBox(height: 10),
          generoBoxButton(),
          buttonSendInfo()
        ],
      ),
    );
  }

  ClipPath crearPortada() {
    return ClipPath(
      child: Container(
        width: 450,
        height: 180,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Image.asset(
          'assets/Login.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container crearPublicidad() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(5),
      child: const Text(
        'Recomendacion del mes, Black food - Roma CDMX                         ',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Divider _divider() {
    return const Divider(
      height: 20, // Altura del separador
      color: Color.fromARGB(255, 255, 255, 255), // Color del separador
      thickness: 2, // Grosor del separador
      indent: 20, // Espaciado izquierdo del separador
      endIndent: 20, // Espaciado derecho del separador
    );
  }

  Container logo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
      child: Image.asset(
        'assets/LogoWhite.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Container nameInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _firstController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Nombre',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.person_2_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu nombre';
            }

            return null;
          }),
    );
  }

  Container lastInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _lastController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Apellido',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.person_2_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu apellido';
            }

            return null;
          }),
    );
  }

  Container emailInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Correo',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.email_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu correo';
            }

            String? isValid = validateEmail(value);
            if (isValid != null) {
              return isValid;
            }

            return null;
          }),
    );
  }

  Container passwordInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _passwordController,
        obscureText: typePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Contraseña',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                typePassword = !typePassword;
              });
            },
            child: Icon(typePassword == true
                ? Icons.lock_clock_outlined
                : Icons.lock_open_sharp),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }

          String? isValid = validatePasswords();
          if (isValid != null) {
            return isValid;
          }

          return null;
        },
      ),
    );
  }

  Container confirPassworInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: typePasswordConfirm,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          label: const Text(
            'Confirmar contraseña',
            style: TextStyle(color: Colors.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                typePasswordConfirm = !typePasswordConfirm;
              });
            },
            child: Icon(typePasswordConfirm == true
                ? Icons.lock_outline
                : Icons.lock_open),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }

          String? isValid = validatePasswords();
          if (isValid != null) {
            return isValid;
          }
          return null;
        },
      ),
    );
  }

  Container rfcInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _rfcController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'RFC',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.edit_document),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu Rfc';
            }

            return null;
          }),
    );
  }

  Container razonSocial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _razonSocialController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Razon Social',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.factory),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu Razon Social';
            }

            return null;
          }),
    );
  }

  Container telefonoInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
          controller: _telefonoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            label: const Text(
              'Telefono',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.phone_android_rounded),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu telefono';
            }

            return null;
          }),
    );
  }

  Container paisSelect() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<Pais>>(
          future: futurePais,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //return Text('aa');
              return DropdownButtonFormField(
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (Pais? newValue) {
                  print(newValue);

                  setState(() {
                    _selectedPais = newValue as Pais;
                    //if (_selectedEstado == null) {
                    _selectedEstado = null;
                    futureEstado = fetchEstados();
                    //}
                  });
                },
                value: _selectedPais,
                items: snapshot.data?.map<DropdownMenuItem<Pais>>((Pais value) {
                  return DropdownMenuItem<Pais>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  Container estadoSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<List<Estado>>(
        future: futureEstado,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField(
              value: _selectedEstado,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (Estado? newValue) {
                print(newValue);
                setState(() {
                  _selectedEstado = newValue;
                  _selectedCiudad = null;
                  futureCiudad = fetchCiudades();
                });
              },
              items:
                  snapshot.data?.map<DropdownMenuItem<Estado>>((Estado value) {
                return DropdownMenuItem<Estado>(
                  value: value,
                  child: Text(value.label),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Text('Seleccione Estado');
        },
      ),
    );
  }

  Container ciudadSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<List<Ciudad>>(
        future: futureCiudad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButtonFormField(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (Ciudad? newValue) {
                print(newValue);
                setState(() {
                  _selectedCiudad = newValue;
                });
              },
              value: _selectedCiudad,
              items:
                  snapshot.data?.map<DropdownMenuItem<Ciudad>>((Ciudad value) {
                return DropdownMenuItem<Ciudad>(
                  value: value,
                  child: Text(value.statecity),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Text('Seleccione Ciudad');
        },
      ),
    );
  }

  Container codigoPostalSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Autocomplete<CodigoPostal>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<CodigoPostal>.empty();
          }
          futureCodigosPostales =
              (await fetchCodigosPostales(textEditingValue.text))
                  as List<CodigoPostal>?;
          print(futureCodigosPostales);

          if (futureCodigosPostales == null) {
            return _lastOptions;
          }
          List<CodigoPostal> options = <CodigoPostal>[];
          options = futureCodigosPostales!;
          /*List<CodigoPostal> options = <CodigoPostal>[];
          futureCodigosPostales?.forEach((element) {
            options.add(element);
          });*/
          _lastOptions = options;
          return options;
        },
        onSelected: (CodigoPostal selection) {
          debugPrint('You just selected $selection');
          /*setState(() {
            _selectedCodigoPostal = selection;
          });*/
        },
      ),
    );
  }

  Padding generoBoxButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Seleccione su género:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () => selectGender('Masculino'),
                icon: Icon(
                  Icons.male,
                  color:
                      selectedGender == 'Masculino' ? Colors.blue : Colors.grey,
                ),
                label: Text(
                  'Masculino',
                  style: TextStyle(
                    color: selectedGender == 'Femenino'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedGender == 'Masculino'
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
                  shadowColor: Colors.blue,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => selectGender('Femenino'),
                icon: Icon(
                  Icons.female,
                  color:
                      selectedGender == 'Femenino' ? Colors.pink : Colors.grey,
                ),
                label: Text(
                  'Femenino',
                  style: TextStyle(
                    color: selectedGender == 'Femenino'
                        ? Colors.pink
                        : Colors.grey,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedGender == 'female'
                      ? Colors.pink.shade100
                      : Colors.grey.shade200,
                  shadowColor: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Género seleccionado: $selectedGender',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Container buttonSendInfo() {
    return Container(
      // width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: baseButtom(
        text: 'Registrarse',
        onPressed: _isButtonDisabled
            ? () {}
            : () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    //Llamada a endpoint
                    final registro = await post(
                        '',
                        'admin',
                        'customers',
                        {
                          'customer': {
                            'email': _emailController.text,
                            'firstname': _firstController.text,
                            'lastname': _lastController.text,
                            "group_id": widget.type == 0 ? 5 : 4,
                          },
                          'password': _passwordController.text
                        },
                        '');

                    //print('registro');

                    if (registro == null) {
                      //print('hay error');
                      //print(registro);
                      //ScaffoldMessenger.of(context).showSnackBar(
                      //    SnackBar(
                      //        content: Text(registro['message'])));
                      setState(() {
                        _isButtonDisabled = !_isButtonDisabled;
                      });
                      return;
                    }

                    /*if (registro["message"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(registro["message"])));
                          return;
                        }*/

                    //Creamos mapa para guardar en base de datos local
                    Map<String, dynamic> data = {
                      'id_user': 1,
                      'id': registro['id'],
                      'nombre': _firstController.text,
                      'apellido_paterno': _lastController.text,
                      'username': _emailController.text,
                      'password': _passwordController.text,
                      'group_id': registro['group_id']
                    };

                    //print(data);
                    //print('data');

                    final login = await post(
                        '',
                        '',
                        'integration/customer/token',
                        {
                          'username': _emailController.text,
                          'password': _passwordController.text
                        },
                        '');

                    //Revision de respuesta
                    if (login.runtimeType != String) {
                      //print('hay error');
                      //print(login['message']);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(login['message'])));
                      setState(() {
                        _isButtonDisabled = !_isButtonDisabled;
                      });
                      return;
                    }

                    //print(login);

                    if (widget.type == 1 && registro['group_id'] == 5) {
                      final update =
                          await put(login, 'custom', 'customergroup/', {}, '4');

                      //print(update);

                      if (update != null) {
                        data['group_id'] = update['data']['new_group_id'];
                      }
                    }

                    final user =
                        await serviceDB.instance.getById('users', 'id_user', 1);
                    //print('usuario');
                    //print(user);
                    //Si existen datos en base de datos local actualizamos datos en mapa
                    if (user.isNotEmpty) {
                      await serviceDB.instance
                          .updateRecord('users', data, 'id_user', 1);
                    } else {
                      //Si no existen datos en base de datos local insertamos datos en mapa
                      data['id_user'] = 1;
                      await serviceDB.instance.insertRecord('users', data);
                    }

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        widget.type == 0 ? 'home' : 'home-rest',
                        (Route<dynamic> route) => false);
                  } catch (e) {
                    setState(() {
                      _isButtonDisabled = !_isButtonDisabled;
                    });
                    //print(e);
                  }
                }
              },
      ),
    );
  }
}

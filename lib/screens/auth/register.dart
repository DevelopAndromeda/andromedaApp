import 'package:andromeda/services/catalog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:andromeda/blocs/login/login_bloc.dart';

import 'package:andromeda/services/api.dart';

import 'package:andromeda/utilities/strings.dart';
import 'package:andromeda/utilities/constanst.dart';

import 'package:andromeda/models/paises.dart';
import 'package:andromeda/models/estados.dart';
import 'package:andromeda/models/ciudades.dart';
import 'package:andromeda/models/codigospostales.dart';

import 'package:andromeda/witgets/button_base.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key, required this.type});
  final int type;

  @override
  // ignore: library_private_types_in_public_api
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
  final TextEditingController _generoController = TextEditingController();

  final CatalogService _catalogService = CatalogService();

  bool typePassword = true;
  bool typePasswordConfirm = true;

  late Future<List<Pais>>? futurePais;
  Pais? _selectedPais;

  Future<List<Estado>>? futureEstado;
  Estado? _selectedEstado;

  Future<List<Ciudad>>? futureCiudad;
  Ciudad? _selectedCiudad;

  List<CodigoPostal>? futureCodigosPostales = <CodigoPostal>[];
  List<CodigoPostal> _lastOptions = <CodigoPostal>[];

  String? validatePasswords() {
    return _passwordController.text != _confirmPasswordController.text
        ? 'Las contraseñas no coinciden'
        : null;
  }

  Future<List<CodigoPostal>> fetchCodigosPostales(String code) async {
    String url =
        "threedadv-sepomex/zip_code_full_wiew/search?searchCriteria[filterGroups][0][filters][1][field]=codigo_postal&searchCriteria[filterGroups][0][filters][1][value]=$code&searchCriteria[filterGroups][0][filters][1][conditionType]=eq&searchCriteria[currentPage]=1&searchCriteria[pageSize]=20";
    if (_selectedCiudad != null) {
      url =
          "$url&searchCriteria[filterGroups][1][filters][0][field]=nombre_estado&searchCriteria[filterGroups][1][filters][0][value]=${_selectedEstado?.label}&searchCriteria[filterGroups][1][filters][0][conditionType]=eq";
    }
    final responseJson = await get('', 'integration', url);
    return (responseJson['items'] as List)
        .map((data) => CodigoPostal.fromJson(data))
        .toList();
  }

  List<DropdownMenuItem<String>> get _genero {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("Hombre")),
      const DropdownMenuItem(value: "2", child: Text("Mujer")),
      const DropdownMenuItem(value: "3", child: Text("No espesificado"))
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    futurePais = _catalogService.fetchPaises();
  }

  @override
  void dispose() {
    super.dispose();
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
          /*generoSelect(),
          const SizedBox(height: 10),*/
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
          buttonSendInfo()
        ],
      ),
    );
  }

  Form clietForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          generoSelect(),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: paisSelect()),
              Expanded(child: estadoSelect()),
            ],
          ),
          const SizedBox(height: 10),
          ciudadSelect(),
          const SizedBox(height: 10),
          /*codigoPostalSelect(),
          const SizedBox(height: 10),*/
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
              'Nombre',
              style: TextStyle(color: Colors.grey),
            ),
            suffixIcon: const Icon(Icons.person_2_outlined),
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
          ////
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
            //
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
          //
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(color: Colors.black)),
        child: FutureBuilder<List<Pais>>(
          future: futurePais,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //return Text('aa');
              return DropdownButtonFormField(
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 25,
                elevation: 15,
                isExpanded: true,
                style: const TextStyle(color: Colors.black),
                validator: (Pais? value) {
                  if (value == null) {
                    return 'Seleccione  un pais';
                  }
                  return null;
                },
                onChanged: (Pais? newValue) {
                  setState(() {
                    _selectedPais = newValue as Pais;
                    //if (_selectedEstado == null) {
                    _selectedEstado = null;
                    futureEstado = futureEstado =
                        _catalogService.fetchEstados("${_selectedPais?.code}");
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
            return const SizedBox(
              height: 50,
              child: Text('Seleccione Pais'),
            );
          },
        ));
  }

  Container estadoSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.blueGrey)),
      child: FutureBuilder<List<Estado>>(
        future: futureEstado,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Text('Seleccione Estado');
            }
            return DropdownButtonFormField(
              value: _selectedEstado,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 25,
              elevation: 15,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              borderRadius: BorderRadius.circular(40),
              validator: (Estado? value) {
                if (value == null) {
                  return 'Seleccione un estado';
                }
                return null;
              },
              onChanged: (Estado? newValue) {
                setState(() {
                  _selectedEstado = newValue;
                  _selectedCiudad = null;
                  futureCiudad =
                      _catalogService.fetchCiudades("${_selectedEstado?.code}");
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
          return const SizedBox(
            height: 50,
            child: Text('Seleccione Estado'),
          );
        },
      ),
    );
  }

  Container ciudadSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: Colors.black)),
      child: FutureBuilder<List<Ciudad>>(
        future: futureCiudad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              //responseWarning(context, "No encontramos resultados :( ");
            }
            return DropdownButtonFormField(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              isExpanded: true,
              validator: (Ciudad? value) {
                if (value == null) {
                  return 'Seleccione una ciudad';
                }
                return null;
              },
              onChanged: (Ciudad? newValue) {
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
          return const SizedBox(
            height: 50,
            width: double.infinity,
            child: Text('Seleccione Ciudad'),
          );
        },
      ),
    );
  }

  Container codigoPostalSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(color: Colors.black)),
      child: Autocomplete<CodigoPostal>(
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<CodigoPostal>.empty();
          }
          futureCodigosPostales =
              (await fetchCodigosPostales(textEditingValue.text));

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

  Container generoSelect() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(color: Colors.black)),
        child: DropdownButtonFormField<String>(
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          isExpanded: true,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese Genero';
            }
            return null;
          },
          onChanged: (String? newValue) {
            setState(() {
              _generoController.text = newValue!;
            });
          },
          items: _genero.toList(),
        ));
  }

  Container buttonSendInfo() {
    return Container(
      // width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: baseButtom(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            Map<String, dynamic> data = {
              'email': _emailController.text,
              'firstname': _firstController.text,
              'lastname': _lastController.text,
              'group_id': widget.type == 0 ? 5 : 4,
              'gender': _generoController.text,
              'password': _passwordController.text
            };
            context.read<AuthLogic>().createAccountLogic(data, context);
          } else {
            responseErrorWarning(context, MyString.required);
            return;
          }
        },
        text: BlocBuilder<AuthLogic, AuthState>(builder: (context, state) {
          if (state is LoginLoadingState) {
            return state.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Registrarse",
                    style: TextStyle(fontSize: 18, color: Colors.white));
          } else {
            return const Text(
              "Registrarse",
              style: TextStyle(fontSize: 18, color: Colors.white),
            );
          }
        }),
      ),
    );
  }
}

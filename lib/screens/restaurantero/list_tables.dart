import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:appandromeda/witgets/colores_base.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListTables extends StatefulWidget {
  const ListTables({super.key});

  @override
  _ListTables createState() => _ListTables();
}

class _ListTables extends State<ListTables> {
  List<Map<String, dynamic>> _transformableBoxes = [];
  final TextEditingController _nameController = TextEditingController();
  //int _pisoCounter = 0;
  //int _zonaCounter = 0;

  final Map<String, Color> _colorMap = {
    'Piso': const Color.fromARGB(255, 151, 196, 232),
    'Zona': Colors.yellow,
    'Mesas': Colors.white,
  };

  final Map<String, Size> _sizeMap = {
    'Piso': Size(300, 300),
    'Zona': Size(200, 200),
    'Mesas': Size(100, 100),
  };

  final List<int> tamanios = [2, 4, 6, 8, 10, 12];

  Future<void> _showNameDialog(
      String type, void Function(String, int?) onNameSubmitted) async {
    //final TextEditingController _nameController = TextEditingController();
    int? selectedPiso;
    String? selectedZona;
    String? selectedForma;

    // Si el tipo es 'Zona', obtenemos la lista de Pisos
    List pisos = _transformableBoxes
        .where((box) => box['option'] == 'Piso')
        .map((box) => box['name'])
        .toList();

    List<String> mesas = [
      "Cuadrada",
      "Rectangular",
      "Redonda",
      "Silla para barra"
    ];

    /*Map<String, dynamic> opcionesMesas = {
      "Cuadrada": ["Alta", "Sala"],
      "Rectangular": ["Habitual"],
      "Redonda": ["Otro"],
      "Silla para barra": ["Otro"]
    };*/

    List<String> zonas = [
      "Barra",
      "Planta Alta",
      "Salón",
      "Bar",
      "Terraza",
      "Otro"
    ];

    //List<String> varintes = [];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese el nombre para $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == 'Piso')
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
              if (type == 'Zona')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Seleccionar Tipo',
                  ),
                  value: selectedZona,
                  items: zonas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedZona = value;
                    });
                  },
                ),
              if (type == 'Zona')
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Seleccionar Piso',
                  ),
                  value: selectedPiso,
                  items: pisos.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPiso = value;
                    });
                  },
                ),
              if (type == 'Mesas')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Seleccionar Forma',
                  ),
                  value: selectedForma,
                  items: mesas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedForma = value;
                    });
                    //print(value);
                    //print(opcionesMesas[value]);}
                    //varintes = [];
                    /*≤xvarintes = opcionesMesas[value];
                    setState(() {
                      varintes = opcionesMesas[value];
                      //selectedPiso = value;
                    });*/
                  },
                ),
              /*if (type == 'Mesas')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Seleccionar Variante',
                  ),
                  //value: selectedPiso,
                  items: varintes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),*/
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (type == 'Piso') {
                  final name = _nameController.text.trim();
                  if (type == 'Piso' && name.isNotEmpty) {
                    Navigator.of(context).pop();
                    onNameSubmitted(name, selectedPiso);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('El nombre no puede estar vacío.')),
                    );
                  }
                } else if (type == 'Mesas') {
                  Navigator.of(context).pop();
                  onNameSubmitted(selectedForma ?? '', selectedPiso);
                } else {
                  Navigator.of(context).pop();
                  onNameSubmitted(selectedZona ?? '', selectedPiso);
                }
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _addTransformableBox(String option, String name, int? parentIndex) {
    setState(() {
      final Size size = _sizeMap[option]!;
      final positionX = 30.0 * _transformableBoxes.length;
      final positionY = 30.0 * _transformableBoxes.length;

      Rect parentRect;
      if (parentIndex != null) {
        parentRect = _transformableBoxes[parentIndex]['rect'];
      } else {
        parentRect = Rect.fromLTWH(
          positionX,
          positionY,
          size.width,
          size.height,
        );
      }

      final rect = Rect.fromLTWH(
        parentRect.left + 20,
        parentRect.top + 20,
        size.width,
        size.height,
      ).intersect(parentRect);

      _transformableBoxes.add({
        'option': option,
        'name': name, // Agrega el nombre
        'rect': rect,
        'parentIndex': parentIndex, // Guarda el índice del padre
        'identifier': '',
        'seating': '',
        'typeChair': ''
      });
    });
  }

  void _removeTransformableBox(int index) {
    setState(() {
      _transformableBoxes.removeAt(index);

      /*if (removedBox['option'] == 'Piso') {
        _pisoCounter =
            _transformableBoxes.where((box) => box['option'] == 'Piso').length +
                1;
      } else if (removedBox['option'] == 'Zona') {
        _zonaCounter =
            _transformableBoxes.where((box) => box['option'] == 'Zona').length +
                1;
      }*/
    });
  }

  bool _isInside(Rect inner, Rect outer) {
    return outer.contains(inner.topLeft) && outer.contains(inner.bottomRight);
  }

  void _handleTransformChange(int index, Rect newRect) {
    final currentBox = _transformableBoxes[index];
    final option = currentBox['option'];

    if (option == 'Zona') {
      for (var box in _transformableBoxes) {
        if (box['option'] == 'Piso') {
          final pisoRect = box['rect'];
          if (_isInside(newRect, pisoRect)) {
            final maxWidth = pisoRect.width - (newRect.left - pisoRect.left);
            final maxHeight = pisoRect.height - (newRect.top - pisoRect.top);
            final constrainedWidth = newRect.width.clamp(0.0, maxWidth);
            final constrainedHeight = newRect.height.clamp(0.0, maxHeight);

            setState(() {
              _transformableBoxes[index]['rect'] = Rect.fromLTWH(
                newRect.left,
                newRect.top,
                constrainedWidth.toDouble(),
                constrainedHeight.toDouble(),
              );
            });
            break;
          }
        }
      }
    } else {
      setState(() {
        _transformableBoxes[index]['rect'] = newRect;
      });
    }
  }

  void _showOptionsDialog(Map<String, dynamic> data, int index) {
    final TextEditingController _idTableController = TextEditingController();
    int? selectedPersonTable;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opciones para ${data['option']} ${data['name']}'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            if (data['option'] == 'Mesas')
              TextField(
                controller: _idTableController,
                decoration: InputDecoration(
                  labelText: 'Identificador',
                ),
              ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Numero de Asientos',
              ),
              value: selectedPersonTable,
              items: tamanios.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                //print(value);
                setState(() {
                  selectedPersonTable = value;
                });
              },
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Numero de Asientos',
              ),
              value: selectedPersonTable,
              items: tamanios.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                print(value);
                setState(() {
                  selectedPersonTable = value;
                });
              },
            ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                bool exists = _transformableBoxes
                    .any((box) => box['identifier'] == _idTableController.text);

                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'El Id: ${_idTableController.text} ya se ecuentra registrado')),
                  );
                  return;
                } else {
                  setState(() {
                    _transformableBoxes[index]['identifier'] =
                        _idTableController.text;
                    _transformableBoxes[index]['seating'] = selectedPersonTable;
                  });
                }
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion de Mesas',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pushNamed(context, 'profile'),
          color: Colors.white,
        ),
        elevation: 1,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        child: Stack(
          children: [
            for (int i = 0; i < _transformableBoxes.length; i++)
              TransformableBox(
                rect: _transformableBoxes[i]['rect'],
                clampingRect: Offset.zero & MediaQuery.of(context).size,
                visibleHandles: {},
                onChanged: (result, event) {
                  _handleTransformChange(i, result.rect);
                },
                contentBuilder: (context, rect, flip) {
                  final name = _transformableBoxes[i]['name']
                          .replaceAll(RegExp(r' '), '_') ??
                      '';

                  if (_transformableBoxes[i]['option'] == 'Mesas') {
                    return GestureDetector(
                        onLongPress: () {
                          _showOptionsDialog(_transformableBoxes[i], i);
                        },
                        onDoubleTap: () => _removeTransformableBox(i),
                        child: Container(
                          child: Stack(
                            children: [
                              // Aquí puedes agregar el SVG
                              Positioned.fill(
                                child: SvgPicture.asset(
                                  "assets/svg/$name.svg",
                                  fit: BoxFit
                                      .contain, // Ajusta el fit según sea necesario
                                ),
                              ),
                              Center(
                                child: Text(_transformableBoxes[i]['identifier']
                                    .toString()),
                              ),
                              // Agregar más widgets si es necesario, como texto o íconos
                            ],
                          ),
                        )

                        /*CustomPaint(
                        painter: TablePainter(),
                        size: Size(rect.width, rect.height),
                      ),*/
                        );
                  } else {
                    return GestureDetector(
                      onLongPress: () {
                        //_showOptionsDialog(boxType, i);
                      },
                      onDoubleTap: () => _removeTransformableBox(i),
                      child: Stack(
                        children: [
                          // El Container con el color de fondo
                          Container(
                            color: _colorMap[_transformableBoxes[i]['option']],
                            child: SizedBox
                                .expand(), // Asegura que el Container ocupe todo el espacio disponible
                          ),
                          // El texto flotante
                          Positioned(
                            top:
                                9.0, // Ajusta la posición vertical según sea necesario
                            left:
                                8.0, // Ajusta la posición horizontal según sea necesario
                            child: Text(
                              name,
                              style: TextStyle(
                                color:
                                    _transformableBoxes[i]['option'] == 'Piso'
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.add),
                    label: 'Agregar Mesas',
                    backgroundColor: Colors.white,
                    onTap: () {
                      /*if (!_transformableBoxes
                          .any((box) => box['option'] == 'Zona')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Debe existir una Zona para crear Mesas.')),
                        );
                        return;
                      }*/
                      _showNameDialog('Mesas', (name, selectedPiso) {
                        _addTransformableBox('Mesas', name, null);
                      });
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.add),
                    label: 'Agregar Zona',
                    backgroundColor: Colors.yellow,
                    onTap: () {
                      if (!_transformableBoxes
                          .any((box) => box['option'] == 'Piso')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Debe existir un Piso para crear una Zona.')),
                        );
                        return;
                      }
                      _showNameDialog('Zona', (name, selectedPiso) {
                        if (selectedPiso != null) {
                          _addTransformableBox('Zona', name, selectedPiso);
                        }
                      });
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.add),
                    label: 'Agregar Piso',
                    backgroundColor: Color.fromARGB(255, 151, 196, 232),
                    onTap: () {
                      _showNameDialog('Piso', (name, selectedPiso) {
                        _addTransformableBox('Piso', name, null);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final tableSize = Size(20, 20);
    final spacing = 10.0;
    for (double x = spacing; x < size.width; x += tableSize.width + spacing) {
      for (double y = spacing;
          y < size.height;
          y += tableSize.height + spacing) {
        final rect = Rect.fromLTWH(x, y, tableSize.width, tableSize.height);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

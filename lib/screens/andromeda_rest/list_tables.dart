import 'package:flutter/material.dart';

//import 'package:andromeda/utilities/constanst.dart';
import 'package:andromeda/witgets/colores_base.dart';

class ListTables extends StatefulWidget {
  const ListTables({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListTables createState() => _ListTables();
}

class _ListTables extends State<ListTables> {
  List<WidgetData> _widgets = [];

  void _addWidget(String type) {
    setState(() {
      switch (type) {
        /*case 'Text':
          _widgets.add(WidgetData(
            widget: MoveableStackItem(
              child: Text('New Text Widget', style: TextStyle(fontSize: 20)),
              onPositionChanged: (newPosition) {
                // No action needed here; handled in _ListTables
              },
              initialPosition: Offset(100, 100), // Starting position
            ),
            position: Offset(100, 100), // Starting position
          ));
          break;
        case 'Button':
          _widgets.add(WidgetData(
            widget: MoveableStackItem(
              child:
                  ElevatedButton(onPressed: () {}, child: Text('New Button')),
              onPositionChanged: (newPosition) {
                // No action needed here; handled in _ListTables
              },
              initialPosition: Offset(100, 200), // Starting position
            ),
            position: Offset(100, 200), // Starting position
          ));
          break;*/
        case 'Zone':
          _widgets.add(WidgetData(
            widget: MoveableStackItem(
              child: Container(width: 150, height: 150, color: Colors.grey),
              onPositionChanged: (newPosition) {
                // No action needed here; handled in _ListTables
              },
              initialPosition: Offset(100, 300), // Starting position
            ),
            position: Offset(100, 300), // Starting position
          ));
          break;
        // Add more widget types as needed
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Drag and Drop Editor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show a dialog to select the type of widget to add
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Widget'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Text Widget'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _addWidget('Text');
                          },
                        ),
                        ListTile(
                          title: Text('Button Widget'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _addWidget('Button');
                          },
                        ),
                        ListTile(
                          title: Text('Zona Widget'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _addWidget('Zone');
                          },
                        ),
                        // Add more options as needed
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: _widgets.map((widgetData) {
          return Positioned(
            left: widgetData.position.dx,
            top: widgetData.position.dy,
            child: DraggableWidget(
              child: widgetData.widget,
              onDragEnd: (details) {
                setState(() {
                  widgetData.position = details.offset; // Update position
                });
              },
            ),

            /*MoveableStackItem(
              child: widgetData.widget,
              onPositionChanged: (newPosition) {
                setState(() {
                  widgetData.position = newPosition; // Update position
                });
              },
              initialPosition: widgetData.position, // Pass initial position
            ),*/
          );
        }).toList(),
      ),

      /*Stack(
        children: _widgets.map((widgetData) {
          return Positioned(
            left: widgetData.position.dx,
            top: widgetData.position.dy,
            child: DraggableWidget(
              child: widgetData.widget,
              onDragEnd: (details) {
                setState(() {
                  widgetData.position = details.offset; // Update position
                });
              },
            ),
          );
        }).toList(),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle saving or other actions
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class DraggableWidget extends StatelessWidget {
  final Widget child;
  final Function(DraggableDetails) onDragEnd;

  DraggableWidget({required this.child, required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: child,
      feedback: Material(
        child: child,
        elevation: 6.0,
      ),
      childWhenDragging:
          Container(), // Optionally display a placeholder when dragging
      onDragEnd: onDragEnd,
    );
  }
}

class WidgetData {
  Widget widget;
  Offset position;

  WidgetData({required this.widget, required this.position});
}

class MoveableStackItem extends StatefulWidget {
  final Widget child;
  final ValueChanged<Offset> onPositionChanged;
  final Offset initialPosition;

  MoveableStackItem({
    required this.child,
    required this.onPositionChanged,
    required this.initialPosition,
  });

  @override
  State<StatefulWidget> createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  late double xPosition;
  late double yPosition;

  @override
  void initState() {
    super.initState();
    xPosition = widget.initialPosition.dx;
    yPosition = widget.initialPosition.dy;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (tapInfo) {
        setState(() {
          xPosition += tapInfo.delta.dx;
          yPosition += tapInfo.delta.dy;
        });
        widget.onPositionChanged(Offset(xPosition, yPosition));
      },
      child: widget.child,
    );
  }
}

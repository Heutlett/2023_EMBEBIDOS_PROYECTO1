import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:house_app/services/house_service.dart';

class DiagramScreen extends StatefulWidget {
  const DiagramScreen({super.key});

  @override
  State<DiagramScreen> createState() => _DiagramScreenState();
}

class _DiagramScreenState extends State<DiagramScreen> {
  bool isOnLuzCuarto1 = false;
  bool isOnLuzCuarto2 = false;
  bool isOnLuzSala = false;
  bool isOnLuzComedor = false;
  bool isOnLuzCocina = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 8, 45, 82),
        child: GestureDetector(
          onTap: () {
            _takePhoto();
          },
          child: Center(
            child: Container(
              width: 230,
              color: Colors.amber,
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tomar foto y filtrarla'),
                  Icon(Icons.camera_alt_outlined)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _takePhoto() async {
    var response = await takePhoto();

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final image = Image.memory(bytes);
      if (context.mounted) {
        _openBottomSheet(context, image);
      }

      // Ahora puedes mostrar la imagen en tu aplicación Flutter
    } else {
      throw Exception('No se pudo cargar la imagen');
    }
  }

  void encenderTodasLuces() async {
    setState(() {
      isOnLuzCocina = true;
      isOnLuzComedor = true;
      isOnLuzCuarto1 = true;
      isOnLuzCuarto2 = true;
      isOnLuzSala = true;
    });
    await changeLightState('living-room', 1);
    await changeLightState('bedroom1', 1);
    await changeLightState('bedroom2', 1);
    await changeLightState('kitchen', 1);
    await changeLightState('dinning-room', 1);
  }

  void apagarTodasLuces() async {
    setState(() {
      isOnLuzCocina = false;
      isOnLuzComedor = false;
      isOnLuzCuarto1 = false;
      isOnLuzCuarto2 = false;
      isOnLuzSala = false;
    });

    await changeLightState('living-room', 0);
    await changeLightState('bedroom1', 0);
    await changeLightState('bedroom2', 0);
    await changeLightState('kitchen', 0);
    await changeLightState('dinning-room', 0);
  }

  void _openBottomSheet(BuildContext context, Image image) {
    showModalBottomSheet(
      elevation: 0,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 700,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Imagen tomada:",
                    style: TextStyle(fontSize: 24),
                  ),
                  image,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Salir'))
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class Luz extends StatefulWidget {
  String name;
  bool isOn;
  int angle;

  Luz({
    super.key,
    required this.name,
    required this.isOn,
    required this.angle,
  });

  @override
  State<Luz> createState() => _LuzState();
}

class _LuzState extends State<Luz> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              widget.isOn = !widget.isOn;
            });
            if (widget.isOn) {
              await changeLightState(widget.name, 1);
            } else {
              await changeLightState(widget.name, 0);
            }
          },
          child: Transform.rotate(
            angle: widget.angle *
                3.14159265359 /
                180, // Ángulo de rotación en radianes (45 grados)
            child: Icon(
              widget.isOn ? Icons.light : Icons.light_outlined,
              size: 55,
              color: widget.isOn ? Colors.green : Colors.grey,
              shadows: [
                widget.isOn
                    ? const Shadow(
                        color: Colors.yellow,
                        blurRadius: 15,
                        offset: Offset(0, 25),
                      )
                    : const Shadow()
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Puerta extends StatefulWidget {
  final String name;
  final int angle;
  const Puerta({
    super.key,
    required this.name,
    required this.angle,
  });

  @override
  State<Puerta> createState() => _PuertaState();
}

class _PuertaState extends State<Puerta> {
  int isOpen = 0;

  @override
  void initState() {
    super.initState();

    // // Utiliza un Timer.periodic para obtener el estado del LED cada 2 segundos.
    // Timer.periodic(const Duration(seconds: 2), (timer) {
    //   getDoorState(widget.name).then((response) {
    //     setState(() {
    //       isOpen = jsonDecode(response.body)['data']['state'];
    //     });
    //   }).catchError((error) {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Transform.rotate(
          angle: widget.angle *
              3.14159265359 /
              180, // Ángulo de rotación en radianes (45 grados)
          child: Icon(
            isOpen == 0 ? Icons.door_back_door_outlined : Icons.door_back_door,
            size: 55,
            color: isOpen == 1 ? Colors.green : Colors.red,
          ),
        )
      ],
    );
  }
}

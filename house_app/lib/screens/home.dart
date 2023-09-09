import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:house_app/services/house_service.dart';
import 'package:house_app/widgets/general/my_button.dart';
import 'package:house_app/widgets/general/my_text.dart';
import 'package:house_app/widgets/general/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House Controller App'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const MyText(
                text: 'Inicio de Sesión',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Nombre de usuario',
                controller: _usernameController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Contraseña',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 20.0),
              MyButton(
                text: 'Iniciar sesión',
                function: () => _submitForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiagramPage(BuildContext context) {
    Navigator.of(context).pushNamed("/diagram");
  }

  Future<void> _submitForm(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    var response = await postLogin(username, password);
    var data = jsonDecode(response.body);

    if (data['data']['valid'] == true) {
      if (context.mounted) {
        showAlertDialog(context, 'Resultado de inicio sesion', '', 'Ok');

        _showDiagramPage(context);
      }
    } else {
      if (context.mounted) {
        showAlertDialog(
            context, "Resultado de inicio sesion", data['data']['msg'], 'Ok');
      }
    }
  }
}

void showAlertDialog(
  BuildContext context,
  String title,
  String message,
  String buttonText,
) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(buttonText),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

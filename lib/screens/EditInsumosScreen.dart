import 'package:consumodeapis/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditInsumosScreen extends StatefulWidget {
  final Insumo insumo;

  EditInsumosScreen({required this.insumo});

  @override
  _EditInsumosScreenState createState() => _EditInsumosScreenState();
}

class _EditInsumosScreenState extends State<EditInsumosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _medidaController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.insumo.nombre);
    _medidaController = TextEditingController(text: widget.insumo.medida);
    _stockController = TextEditingController(text: widget.insumo.stock.toString());
  }

  Future<void> _updateInsumo() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://jpnet08-001-site1.htempurl.com/SENA/clientes/${widget.insumo.id}');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'your-user-agent',
          'Authorization': 'Basic ' + base64Encode(utf8.encode('11178839:60-dayfreetrial')),
        },
        body: jsonEncode({
          'id': widget.insumo.id,
          'nombre': _nombreController.text,
          'medida': _medidaController.text,
          'stock': int.parse(_stockController.text),
        }),
      );

      if (response.statusCode == 204) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el insumo: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medidaController,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una Identificación';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un número telefónico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateInsumo,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

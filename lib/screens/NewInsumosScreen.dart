import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewInsumosScreen extends StatefulWidget {
  @override
  _NewInsumosScreenState createState() => _NewInsumosScreenState();
}

class _NewInsumosScreenState extends State<NewInsumosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _medidaController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Cliente'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _medidaController,
              decoration: const InputDecoration(labelText: 'Identificación'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la identificación';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el número telefónico';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Confirmar número'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor confirma el número de telefono';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: const Text('Guardar'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final nuevoInsumo = {
        'nombre': _nombreController.text,
        'medida': _medidaController.text,
        'stock': int.parse(_stockController.text),
      };

      final url = Uri.parse('http://jpnet08-001-site1.htempurl.com/SENA/clientes');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + base64Encode(utf8.encode('11178839:60-dayfreetrial')),
          },
          body: json.encode(nuevoInsumo),
        );

        if (response.statusCode == 201) {
          Navigator.of(context).pop(true); // Pop la pantalla y devuelve true
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error ${response.statusCode}: ${response.reasonPhrase}';
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $e';
        });
      }
    }
  }
}

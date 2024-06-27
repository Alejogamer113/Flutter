import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:consumodeapis/screens/EditInsumosScreen.dart';
import 'package:consumodeapis/screens/NewInsumosScreen.dart';

void main() {
  runApp(MenuApp());
}

class MenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'Alejo' && password == 'Alejo113') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 45, 251),
        title: Text('Login', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 45, 251),
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



class Insumo {
  final int id;
  final String nombre;
  final String medida;
  final int stock;

  Insumo({
    required this.id,
    required this.nombre,
    required this.medida,
    required this.stock,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      id: json['id'],
      nombre: json['nombre'],
      medida: json['medida'],
      stock: json['stock'],
    );
  }
}

class Devolucion {
  final int id;
  final int comprobante;
  final String productodevuelto;
  final String cliente;
  final DateTime fecha;
  final int catidad;

  Devolucion({
    required this.id,
    required this.comprobante,
    required this.productodevuelto,
    required this.cliente,
    required this.fecha,
    required this.catidad,
  });

  factory Devolucion.fromJson(Map<String, dynamic> json) {
    return Devolucion(
      id: json['id'] ?? 0,
      comprobante: json['comprobante'] ?? 0,
      productodevuelto: json['productodevuelto'] ?? '',
      cliente: json['cliente'] ?? '',
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String()),
      catidad: json['catidad'] ?? 0,
    );
  }
}



class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 45, 251),
        title: Text('CreamySoft', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MenuButton(
                text: 'Ir a Clientes',
                color: const Color.fromARGB(255, 53, 83, 253)!,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListarInsumosScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              MenuButton(
                text: 'Ir a Roles',
                color: const Color.fromARGB(255, 111, 37, 249)!,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListarDevolucionesScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  MenuButton({required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ListarInsumosScreen extends StatefulWidget {
  @override
  _ListarInsumosScreenState createState() => _ListarInsumosScreenState();
}

class _ListarInsumosScreenState extends State<ListarInsumosScreen> {
  List<Insumo> insumos = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    cargarInsumos();
  }

  Future<void> cargarInsumos() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('http://jpnet08-001-site1.htempurl.com/SENA/clientes');
    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'your-user-agent',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('11178839:60-dayfreetrial')),
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          setState(() {
            insumos = jsonData.map((item) => Insumo.fromJson(item)).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'La respuesta de la API no es una lista.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al cargar los Roles: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Excepción al cargar los Roles: $e';
      });
    }
  }

  Future<void> eliminarInsumo(int id) async {
    final url = Uri.parse('http://jpnet08-001-site1.htempurl.com/SENA/clientes/$id');
    try {
      final response = await http.delete(url, headers: {
        'User-Agent': 'your-user-agent',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('11178839:60-dayfreetrial')),
      });

      if (response.statusCode == 204) {
        setState(() {
          insumos.removeWhere((insumo) => insumo.id == id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el Cliente: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción al eliminar el Cliente: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 45, 251),
        title: const Text('Clientes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarInsumos,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: insumos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.yellow[200],
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(insumos[index].nombre),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Medida: ${insumos[index].medida}'),
                              Text('Stock: ${insumos[index].stock}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditInsumosScreen(insumo: insumos[index]),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      cargarInsumos();
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  eliminarInsumo(insumos[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 48, 45, 251),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewInsumosScreen()),
          ).then((value) {
            if (value == true) {
              cargarInsumos();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListarDevolucionesScreen extends StatefulWidget {
  @override
  _ListarDevolucionesScreenState createState() => _ListarDevolucionesScreenState();
}

class _ListarDevolucionesScreenState extends State<ListarDevolucionesScreen> {
  List<Devolucion> devoluciones = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    cargarDevoluciones();
  }

  Future<void> cargarDevoluciones() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('http://jpnet08-001-site1.htempurl.com/SENA/roles');
    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'your-user-agent',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('11178839:60-dayfreetrial')),
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          setState(() {
            devoluciones = jsonData.map((item) => Devolucion.fromJson(item)).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'La respuesta de la API no es una lista.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al cargar las devoluciones: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Excepción al cargar las devoluciones: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 90, 45, 251),
        title: const Text('Roles'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarDevoluciones,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: devoluciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 178, 157, 255),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(devoluciones[index].productodevuelto),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cliente: ${devoluciones[index].cliente}'),
                              Text('Fecha: ${devoluciones[index].fecha.toLocal()}'),
                              Text('catidad: ${devoluciones[index].catidad}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

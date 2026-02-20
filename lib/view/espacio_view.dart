import 'package:flutter/material.dart';
import 'package:organiza_t/database/espacio_crud.dart';
import 'package:organiza_t/model/Espacio.dart';
import 'package:organiza_t/view/utils.dart';
import 'package:organiza_t/view/base_layout.dart';
import 'package:organiza_t/view/estante_view.dart';

///Vista de espacios
class EspacioView extends StatefulWidget {
  const EspacioView({super.key});

  @override
  State<EspacioView> createState() => _EspacioViewState();
}

class _EspacioViewState extends State<EspacioView> {
  List<Espacio> espacios = [];
  late TextEditingController _controllerEspacio;
  late TextEditingController _controllerEspacioUpdate;

  @override
  void initState() {
    super.initState();
    _controllerEspacio = TextEditingController();
    _controllerEspacioUpdate = TextEditingController();
    cargarEspacios();
  }

  @override
  void dispose() {
    _controllerEspacio.dispose();
    _controllerEspacioUpdate.dispose();
    super.dispose();
  }

  void cargarEspacios() async {
    List<Espacio> aux = await EspacioCrud.obtenerTodosEspacios();
    setState(() {
      espacios = aux;
    });
  }

  Future<void> agregarEspacio() async {
    if (_controllerEspacio.text.isNotEmpty) {
      Espacio espacio = Espacio(nombre: _controllerEspacio.text.toUpperCase());
      int id = await EspacioCrud.agregarEspacio(espacio);
      setState(() {
        espacio.id = id;
        espacios.add(espacio);
        _controllerEspacio.clear();
      });
    } else {}
  }

  void modificarEspacio(Espacio espacio) {
    setState(() {
      if (_controllerEspacioUpdate.text.isNotEmpty) {
        espacio.nombre = _controllerEspacioUpdate.text.toUpperCase();
        EspacioCrud.modificarEspacio(espacio);
      }
    });
  }

  void eliminarEspacio(int id) {
    EspacioCrud.eliminarEspacio(id);
    setState(() {
      espacios.removeWhere((item) => item.id == id);
    });
  }

  Widget espacioWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _controllerEspacio,
                  decoration: InputDecoration(
                    hintText: "Añadir espacio",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  if (_controllerEspacio.text.isNotEmpty) {
                    agregarEspacio();
                  } else {
                    Utils.showBannerError(
                      context,
                      "El espacio debe tener un nombre",
                    );
                  }
                },
                child: Icon(Icons.add),
              ),
              SizedBox(width: 8),
            ],
          ),
          Expanded(
            child: espacios.isEmpty
                ? Utils.listaVacia("espacios")
                : ListView.builder(
                    itemCount: espacios.length,
                    itemBuilder: (context, index) {
                      Espacio espacio = espacios[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EstanteView(espacio: espacio),
                                    ),
                                  ),
                                  child: Text(
                                    espacio.nombre,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Utils.muestraEdicion(
                                    context,
                                    _controllerEspacioUpdate,
                                    espacio,
                                    () => modificarEspacio(espacio),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.orange),
                              ),
                              IconButton(
                                onPressed: () => eliminarEspacio(espacio.id!),
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(child: espacioWidget(context));
  }
}

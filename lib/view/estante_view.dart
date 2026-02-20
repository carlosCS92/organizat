import 'package:flutter/material.dart';
import 'package:organiza_t/model/Espacio.dart';
import 'package:organiza_t/model/estante.dart';
import 'package:organiza_t/database/estante_crud.dart';
import 'package:organiza_t/view/utils.dart';
import 'package:organiza_t/view/base_layout.dart';
import 'package:organiza_t/view/producto_view.dart';

///Vista de estantes
class EstanteView extends StatefulWidget {
  final Espacio espacio;
  const EstanteView({super.key, required this.espacio});

  @override
  State<EstanteView> createState() => _EstanteViewState();
}

class _EstanteViewState extends State<EstanteView> {
  List<Estante> estantes = [];
  late TextEditingController _controllerEstante;
  late TextEditingController _controllerEstanteUpdate;

  @override
  void initState() {
    super.initState();
    _controllerEstante = TextEditingController();
    _controllerEstanteUpdate = TextEditingController();
    cargarEstantes();
  }

  @override
  void dispose() {
    _controllerEstante.dispose();
    _controllerEstanteUpdate.dispose();
    super.dispose();
  }

  void cargarEstantes() async {
    List<Estante> aux = await EstanteCrud.obtenerEstantesPorEspacio(
      widget.espacio.id!,
    );
    setState(() {
      estantes = aux;
    });
  }

  Future<void> agregarEstante() async {
    if (_controllerEstante.text.isNotEmpty) {
      Estante estante = Estante(
        nombre: _controllerEstante.text.toUpperCase(),
        espacioId: widget.espacio.id!,
      );
      int id = await EstanteCrud.agregarEstante(estante);
      setState(() {
        estante.id = id;
        estantes.add(estante);
        _controllerEstante.clear();
      });
    }
  }

  void modificarEstante(Estante estante) {
    setState(() {
      estante.nombre = _controllerEstanteUpdate.text.toUpperCase();
      EstanteCrud.modificarEstante(estante);
    });
  }

  void eliminarEstante(int id) {
    EstanteCrud.eliminarEstante(id);
    setState(() {
      estantes.removeWhere((item) => item.id == id);
    });
  }

  Widget estanteWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  widget.espacio.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _controllerEstante,
                  decoration: InputDecoration(
                    hintText: "Añadir estante",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  if (_controllerEstante.text.isNotEmpty) {
                    agregarEstante();
                  } else {
                    Utils.showBannerError(
                      context,
                      "El estante no puede ser vacío",
                    );
                  }
                },
                child: Icon(Icons.add),
              ),
              SizedBox(width: 8),
            ],
          ),
          Expanded(
            child: estantes.isEmpty
                ? Utils.listaVacia("estantes")
                : ListView.builder(
                    itemCount: estantes.length,
                    itemBuilder: (context, index) {
                      Estante estante = estantes[index];
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
                                      builder: (context) => Productoview(
                                        estante: estante,
                                        espacioName: widget.espacio.nombre,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    estante.nombre,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Utils.muestraEdicion(
                                    context,
                                    _controllerEstanteUpdate,
                                    estante,
                                    () => modificarEstante(estante),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.orange),
                              ),
                              IconButton(
                                onPressed: () => eliminarEstante(estante.id!),
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
    return BaseLayout(child: estanteWidget(context));
  }
}

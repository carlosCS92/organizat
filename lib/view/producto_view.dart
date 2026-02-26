import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organiza_t/database/producto_crud.dart';
import 'package:organiza_t/model/estante.dart';
import 'package:organiza_t/model/producto.dart';
import 'package:organiza_t/view/base_layout.dart';
import 'package:organiza_t/view/utils.dart';

///Vista de productos
class Productoview extends StatefulWidget {
  final Estante estante;
  final String espacioName;

  const Productoview({
    super.key,
    required this.estante,
    required this.espacioName,
  });

  @override
  State<Productoview> createState() => _ProductoviewState();
}

class _ProductoviewState extends State<Productoview> {
  List<Producto> productos = [];
  late TextEditingController _controllerProducto;
  late TextEditingController _controllerCantidad;

  String? _medidaSeleccionada = 'Ud';
  List<String> _opcionesMedida = ['Ud', 'Kg', 'g'];

  @override
  void initState() {
    super.initState();
    _controllerProducto = TextEditingController();
    _controllerCantidad = TextEditingController(text: "1");
    cargarProductos();
  }

  @override
  void dispose() {
    _controllerProducto.dispose();
    _controllerCantidad.dispose();
    super.dispose();
  }

  Future<void> agregarProducto() async {
    if (_controllerProducto.text.isNotEmpty) {
      Producto p = Producto(
        nombre: _controllerProducto.text.toUpperCase(),
        cantidad: int.tryParse(_controllerCantidad.text)!,
        medida: _medidaSeleccionada!,
        estanteId: widget.estante.id!,
      );
      int id = await ProductoCrud.agregarProducto(p);

      setState(() {
        p.id = id;
        productos.add(p);
        _controllerProducto.clear();
        _controllerCantidad.text = '1';
      });
    }
  }

  void eliminarProducto(int id) {
    ProductoCrud.eliminarProducto(id);
    setState(() {
      productos.removeWhere((item) => item.id == id);
    });
  }

  void cargarProductos() async {
    List<Producto> aux = await ProductoCrud.obtenerProductosPorEstante(
      widget.estante.id!,
    );
    setState(() {
      productos = aux;
    });
  }

  Widget productoWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  "${widget.estante.nombre} (${widget.espacioName})",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _controllerProducto,
                  decoration: InputDecoration(
                    hintText: "Añadir producto",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _controllerCantidad,
                  keyboardType: TextInputType.number, // solo números
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: // Ejemplo básico de DropdownButton
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  initialValue: _medidaSeleccionada,
                  items: _opcionesMedida.map((String opcion) {
                    return DropdownMenuItem<String>(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (String? nuevoValor) {
                    setState(() {
                      _medidaSeleccionada = nuevoValor;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                height: 48,
                width: 48,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_controllerProducto.text.isEmpty) {
                      Utils.showBannerError(
                        context,
                        "El producto no puede ser vacío",
                      );
                    } else if ((int.tryParse(_controllerCantidad.text) ?? 0) <
                        1) {
                      Utils.showBannerError(
                        context,
                        "La cantidad tiene que ser mayor que 0",
                      );
                    } else {
                      agregarProducto();
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          Expanded(
            child: productos.isEmpty
                ? Utils.listaVacia("productos")
                : ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      Producto producto = productos[index];
                      return Card(
                        //Si la cantidad es menor o igual que 3, se muestra en rojo para avisar de que quedan pocas unidades del producto
                        color: Colors.teal[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              /// 🔹 NOMBRE (ocupa el espacio restante)
                              Expanded(
                                child: Text(
                                  "${producto.nombre} (${producto.medida})",

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 🔹 CONTADOR (ancho fijo para alineación perfecta)
                              SizedBox(
                                width: 130,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// Botón -
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            producto.cantidad--;
                                            if (producto.cantidad == 0) {
                                              productos.remove(producto);
                                            }
                                          });

                                          ProductoCrud.modificarProducto(
                                            producto,
                                          );
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ),

                                    /// Cantidad centrada (sin TextField para evitar rebuild issues)
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        producto.cantidad.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    /// Botón +
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            producto.cantidad++;
                                          });
                                          ProductoCrud.modificarProducto(
                                            producto,
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              /// 🔹 PAPELERA (ancho fijo)
                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  onPressed: () =>
                                      eliminarProducto(producto.id!),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
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
    return BaseLayout(child: productoWidget(context));
  }
}

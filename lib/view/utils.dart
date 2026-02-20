import 'package:flutter/material.dart';

///Clase de elementos en comun
class Utils {
  ///Mostrar banner de error cuando el campo de texto está vacío
  static void showBannerError(BuildContext context, String mensaje) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text(mensaje, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        leading: const Icon(Icons.error, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text("CERRAR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  ///Muestra el Dialog para poder editar el nombre del elemento (estante/espacio)
  static void muestraEdicion(
    BuildContext context,
    TextEditingController controller,
    dynamic item,
    Function onGuardar,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        controller.text = item.nombre;
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 1,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onGuardar();
                      Navigator.pop(context);
                    },
                    child: Text("Guardar"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Muestra una etiqueta indicando que no hay elementos en la lista
  static Widget listaVacia(String elem) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          "No hay $elem".toUpperCase(),
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

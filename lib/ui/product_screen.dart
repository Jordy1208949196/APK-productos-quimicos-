import 'package:firebaseflutter/model/producto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductScreenState extends State<ProductScreen> {
  List<Product> items;
  TextEditingController _nombreproController;
  TextEditingController _nombreController;
  TextEditingController _enfer_controlController;
  TextEditingController _tipoController;
  TextEditingController _precioController;
  TextEditingController _c_comercialController;

  @override
  void initState() {
    super.initState();
    _nombreproController =
        new TextEditingController(text: widget.product.nombrepro);
    _nombreController = new TextEditingController(text: widget.product.nombre);
    _enfer_controlController =
        new TextEditingController(text: widget.product.enfer_control);
    _tipoController = new TextEditingController(text: widget.product.tipo);
    _precioController = new TextEditingController(text: widget.product.precio);
    _c_comercialController =
        new TextEditingController(text: widget.product.c_comercial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AGREGAR O ACTUALIZAR PRODUCTO',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nombreproController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Nombre Comercial'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _nombreController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Nombre ingrediente activo'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _enfer_controlController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Enfermedades que controla'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _tipoController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.list), labelText: 'tipo'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _precioController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on), labelText: 'Precio'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                TextField(
                  controller: _c_comercialController,
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                  decoration: InputDecoration(
                      icon: Icon(Icons.shop), labelText: 'Casa comercial'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),

                // container de boton actualizar o agregar
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 40,
                  margin: EdgeInsets.only(
                    top: 32,
                  ),
                  color: Colors.greenAccent,
                  child: FlatButton(
                      onPressed: () {
                        //actualizar
                        if (widget.product.id != null) {
                          productReference.child(widget.product.id).set({
                            'nombrepro': _nombreproController.text,
                            'nombre': _nombreController.text,
                            'enfer_control': _enfer_controlController.text,
                            'tipo': _tipoController.text,
                            'precio': _precioController.text,
                            'c_comercial': _c_comercialController.text,
                          }).then((_) {
                            Navigator.pop(context);
                          });
                        } else {
                          // crear

                          productReference.push().set({
                            'nombrepro': _nombreproController.text,
                            'nombre': _nombreController.text,
                            'enfer_control': _enfer_controlController.text,
                            'tipo': _tipoController.text,
                            'precio': _precioController.text,
                            'c_comercial': _c_comercialController.text,
                          }).then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: (widget.product.id != null)
                          ? Text('ACTUALIZAR')
                          : Text('AGREGAR')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

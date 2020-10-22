import 'package:firebaseflutter/ui/product_information.dart';
import 'package:firebaseflutter/ui/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebaseflutter/model/producto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProductState extends State<ListViewProduct> {
  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onProductAddedSubscription =
        productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription =
        productReference.onChildChanged.listen(_onProductUpdate);
  }

// cancel
  @override
  void dispose() {
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Listado de productos quimicos'),
            centerTitle: true,
            backgroundColor: Colors.green[300]),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 10.0,
                    ),
                    Container(
                      padding: new EdgeInsets.all(3.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            // listado de productos
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    '${items[position].nombre}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${items[position].tipo}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15.0,
                                    ),
                                  ),

                                  // circulo con numeracion id
                                  leading: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.greenAccent,
                                        radius: 17.0,
                                        child: Text(
                                          '${position + 1}',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () => _navigateToProductInformation(
                                      context, items[position])),
                            ),
                            // icono eliminar
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(context, position),
                            ),
                            // icono ver imformacion producto
                            IconButton(
                                icon: Icon(
                                  Icons.list,
                                  color: Colors.green,
                                ),
                                onPressed: () => _navigateToProduct(
                                    context, items[position])),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.greenAccent,
          onPressed: () => _createNewProduct(context),
        ),
      ),
    );
  }

  //alerta de dialogo antes eliminar productos
  void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ALERTA'),
          content: Text('¿Esta usted seguro de eliminar este producto?'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _deleteProduct(
                context,
                items[position],
                position,
              ),
            ),
            new FlatButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// metodo refresca pantalla al agregar un nuevo producto
  void _onProductAdded(Event event) {
    setState(() {
      items.add(new Product.fromSnapShot(event.snapshot));
    });
  }

  // metodo refresca pantalla al actualizar producto
  void _onProductUpdate(Event event) {
    var oldProductValue =
        items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProductValue)] =
          new Product.fromSnapShot(event.snapshot);
    });
  }

  //metodo para eliminar productos
  void _deleteProduct(
      BuildContext context, Product product, int position) async {
    await productReference.child(product.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
        Navigator.of(context).pop();
      });
    });
  }

  //metodo pasar a pantalla de actualizar producto
  void _navigateToProductInformation(
      BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen(product)),
    );
  }

  //metodo pasar a pantalla informacion de producto
  void _navigateToProduct(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductInformation(product)),
    );
  }

//metodo pasar a pantalla de crear un producto
  void _createNewProduct(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductScreen(Product(null, '', '', '', '', '', ''))),
    );
  }
}

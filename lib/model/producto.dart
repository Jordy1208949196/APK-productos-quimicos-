import 'package:firebase_database/firebase_database.dart';

// componentes de tabla de mi base de datos
class Product {
  String _id;
  String _nombrepro;
  String _nombre;
  String _enfer_control;
  String _tipo;
  String _precio;
  String _c_comercial;

  Product(this._id, this._nombrepro, this._nombre, this._enfer_control,
      this._tipo, this._precio, this._c_comercial);

  // creamos mapa
  /* Product.map(dynamic obj) {
    this._nombrepro = obj['nombrepro'];
    this._nombre = obj['nombre'];
    this._enfer_control = obj['enfer_control'];
    this._tipo = obj['tipo'];
    this._precio = obj['precio'];
    this._c_comercial = obj['c_comercial'];
  } */

  String get id => _id;
  String get nombrepro => _nombrepro;
  String get nombre => _nombre;
  String get enfer_control => _enfer_control;
  String get tipo => _tipo;
  String get precio => _precio;
  String get c_comercial => _c_comercial;

  // captura de informacion (creacion de tabla)
  Product.fromSnapShot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _nombrepro = snapshot.value['nombrepro'];
    _nombre = snapshot.value['nombre'];
    _enfer_control = snapshot.value['enfer_control'];
    _tipo = snapshot.value['tipo'];
    _precio = snapshot.value['precio'];
    _c_comercial = snapshot.value['c_comercial'];
  }
}

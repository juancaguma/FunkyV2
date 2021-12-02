import 'dart:io';
import 'package:rxdart/subjects.dart';
import 'package:colecciona_app/providers/productos_provider.dart';
import 'package:colecciona_app/models/producto_model.dart';

class ProductosBloc {
  final _productosControlle = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoControlle = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream => _productosControlle;
  Stream<bool> get cargando => _cargandoControlle;

  void cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();
    _productosControlle.sink.add(productos);
  }

  void agregarProducto(ProductoModel producto) async {
    _cargandoControlle.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoControlle.sink.add(false);
  }

  Future<String?> subirFoto(File foto) async {
    _cargandoControlle.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoControlle.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(ProductoModel producto) async {
    _cargandoControlle.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoControlle.sink.add(false);
  }

  void borrarProducto(String? id) async {
    await _productosProvider.borrarProducto(id);
  }

  dispose() {
    _productosControlle.close();
    _cargandoControlle.close();
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:colecciona_app/models/producto_model.dart';
import 'package:colecciona_app/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  final String _url = 'flutter-varios-176f0-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = Uri.https(_url, 'productos.json', {'auth': _prefs.token});
    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);

    print(decodeData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = Uri.https(_url, 'productos/${producto.id}.json', {
      'auth': _prefs.token,
    });
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);

    print(decodeData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final uderId = _prefs.idUser;
    //print(uderId);
    final url = Uri.https(_url, 'productos.json', {
      'auth': _prefs.token,
      'orderBy': '"idUser"',
      'equalTo': '"$uderId"',
    });

    final resp = await http.get(url);
    final Map<String, dynamic>? decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = [];
    if (decodeData == null) return [];
    if (decodeData['error'] != null) return [];
    decodeData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }

  Future<int> borrarProducto(String? id) async {
    //final uderId = _prefs.idUser;
    final url = Uri.https(_url, 'productos/$id.json', {
      'auth': _prefs.token,
    });
    final resp = await http.delete(url);
    print(resp);
    return 1;
  }

  Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/deqwb4ocf/image/upload?upload_preset=ymaj1w0z');
    final mimeType = mime(imagen.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}

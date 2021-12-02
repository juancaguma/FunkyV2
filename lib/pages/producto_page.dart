import 'dart:io';
import 'package:colecciona_app/preferencias_usuario/preferencias_usuario.dart';
import 'package:colecciona_app/widgets/menu_widget.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:colecciona_app/bloc/productos_bloc.dart';
import 'package:colecciona_app/bloc/provider.dart';
import 'package:colecciona_app/models/producto_model.dart';
import 'package:colecciona_app/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //final idUser= Usu
  late ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  PreferenciasUsuario userId = new PreferenciasUsuario();
  bool _guardando = false;
  String mensaje = '';
  File? foto;
  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductoModel? prodData =
        ModalRoute.of(context)!.settings.arguments as ProductoModel?;
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Colección'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo_sharp),
            onPressed: _tomarFoto,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (_guardando) ? null : _submit,
          )
        ],
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearTipo(),
                _descripcion(),
                _crearPrecioCompra(),
                _lugarCompra(),
                _crearDisponible(),
                _crearFavorito(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearTipo() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Colección',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _descripcion() {
    return TextFormField(
      initialValue: producto.decripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Descripcion',
      ),
      onSaved: (value) => producto.decripcion = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese la descripción';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecioCompra() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio compra',
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _lugarCompra() {
    return TextFormField(
      initialValue: producto.lugarCompra,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Lugar de compra',
      ),
      onSaved: (value) => producto.lugarCompra = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible!,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearFavorito() {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FavoriteButton(
              isFavorite: producto.favorite!,
              valueChanged: (_isFavorite) {
                producto.favorite = _isFavorite;
              },
            ),
          ],
        ));
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    producto.idUser = userId.idUser;

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto!);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
      mensaje = 'agregado';
    } else {
      productosBloc.editarProducto(producto);
      mensaje = 'actualizado';
    }

    mostrarSnackbar('Producto $mensaje');
    productosBloc.cargarProductos();
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl!),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: (foto != null
            ? FileImage(foto!)
            : AssetImage('assets/no-image.png')) as ImageProvider<Object>,
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final ImagePicker imagePicker = ImagePicker();
    final PickedFile? pickedFile = await imagePicker.getImage(source: origen);
    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
      } else {
        print('No se seleccionó una foto.');
      }
    });
  }
}

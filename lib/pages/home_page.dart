import 'package:colecciona_app/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:colecciona_app/bloc/provider.dart';
import 'package:colecciona_app/models/producto_model.dart';
import 'package:admob_flutter/admob_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu colección'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, "producto")
                  .then((value) => setState(() {})),
              icon: Icon(Icons.add_circle)),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
      drawer: MenuWidget(),
      body: _crearListado(productosBloc),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data!;
          if (productos.length == 0) {
            return Center(
                child: Text(
              'Parece que no tiene elementos en tu colección pulsa (+) para agregar uno.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ));
          } else {
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) =>
                  _crearItem(context, productosBloc, productos[i]),
            );
          }
        } else {
          //print('Entro a else');
          return Center(child: _bottomAdmob());
        }
      },
    );
  }

  Widget _bottomAdmob() {
    return Container(
      color: Colors.red,
      child: AdmobBanner(
          adUnitId: 'ca-app-pub-3940256099942544/5224354917',
          adSize: AdmobBannerSize.BANNER),
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: _color2(producto),
      ),
      onDismissed: (direccion) {
        // setState(() {
        // });
        productosBloc.borrarProducto(producto.id);
        productosBloc.cargarProductos();
      },
      child: Card(
        color: Colors.blueAccent[50],
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, "producto", arguments: producto)
                  .then((value) => setState(() {})),
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(producto.fotoUrl!),
                        height: 250.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
              Container(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(producto.fotoUrl!),
                    ),
                    title: Text('${producto.titulo}'),
                    subtitle: Text(
                      '${producto.decripcion}',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    tileColor: _color(producto),
                    trailing:
                        (producto.favorite == true && producto.favorite != null)
                            ? Icon(
                                Icons.favorite,
                                size: 24.0,
                                color: _color2(producto),
                              )
                            : Icon(
                                Icons.star_border_outlined,
                                size: 24.0,
                                color: _color2(producto),
                              )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _color(ProductoModel producto) {
    if (producto.disponible == true) {
      return Colors.white;
    } else {
      return Colors.red;
    }
  }

  _color2(ProductoModel producto) {
    if (producto.disponible == true) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }
}

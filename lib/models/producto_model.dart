import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String? id;
  String? titulo;
  String? decripcion;
  double? valor;
  String? lugarCompra;
  bool? disponible;
  String? fotoUrl;
  bool? favorite;
  String? idUser;

  ProductoModel({
    this.id,
    this.titulo = '',
    this.decripcion = '',
    this.lugarCompra = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
    this.favorite = false,
    this.idUser = '',
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        decripcion: json["decripcion"],
        lugarCompra: json["lugarCompra"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
        favorite: json["favorite"],
        idUser: json["idUser"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        "titulo": titulo,
        "decripcion": decripcion,
        "lugarCompra": lugarCompra,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
        "favorite": favorite,
        "idUser": idUser,
      };
}

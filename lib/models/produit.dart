import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  String? id;
  String marque;
  String designation;
  String categorie;
  double prix;
  String photo;
  int quantite;

  Produit({
    this.id,
    required this.marque,
    required this.designation,
    required this.categorie,
    required this.prix,
    required this.photo,
    required this.quantite,
  });

  factory Produit.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Produit(
      id: doc.id,
      marque: data['marque'] ?? '',
      designation: data['designation'] ?? '',
      categorie: data['categorie'] ?? '',
      prix: double.parse(data['prix'].toString()),
      photo: data['photo'],
      quantite: data['quantite'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'marque': marque,
    'designation': designation,
    'categorie': categorie,
    'prix': prix,
    'photo': photo,
    'quantite': quantite,
  };
}

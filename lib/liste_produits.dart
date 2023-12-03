import 'package:atelier4_a_almai_iirg6/dialogs/produit_add_dialog.dart';
import 'package:atelier4_a_almai_iirg6/models/produit.dart';
import 'package:atelier4_a_almai_iirg6/widgets/produit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ListeProduits extends StatefulWidget {
  const ListeProduits({super.key});

  @override
  State<ListeProduits> createState() => _ListsProduitStates();
}

class _ListsProduitStates extends State<ListeProduits> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void addProduit(Produit produit) {
    _db.collection('produits').add(produit.toJson());
  }

  void deleteProduit(Produit produit) async {
    await _storage.refFromURL(produit.photo).delete();
    _db.collection('produits').doc(produit.id).delete();
  }

  void showAddProduitDialog() {
    showDialog(
      context: context,
      builder: (context) => ProduitAddDialog(addProduit: addProduit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProduitDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Produit> produits =
              snapshot.data!.docs.map((d) => Produit.fromFirestore(d)).toList();

          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) => ProduitCard(
              produit: produits.elementAt(index),
              deleteProduit: deleteProduit,
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:atelier4_a_almai_iirg6/models/produit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProduitAddDialog extends StatefulWidget {
  final Function(Produit) _addProduit;
  const ProduitAddDialog({super.key, required Function(Produit) addProduit})
      : _addProduit = addProduit;

  @override
  State<ProduitAddDialog> createState() => _ProduitAddDialogState();
}

class _ProduitAddDialogState extends State<ProduitAddDialog> {
  final _categorieController = TextEditingController();
  final _designationController = TextEditingController();
  final _marqueController = TextEditingController();
  final _prixController = TextEditingController();
  final _quatiteController = TextEditingController();
  File? _selectedImage;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _loading = false;

  Future<void> pickImage() async {
    XFile? xFileImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFileImage == null) return;
    setState(() {
      _selectedImage = File(xFileImage.path);
    });
  }

  void _addProduit() async {
    setState(() {
      _loading = true;
    });
    final ref = _storage.ref(_selectedImage!.path.split('/').last);
    final snapshot = await ref
        .putFile(
          _selectedImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        )
        .whenComplete(() => null);
    final imageURL = await snapshot.ref.getDownloadURL();

    widget._addProduit(Produit(
      marque: _marqueController.text,
      designation: _designationController.text,
      categorie: _categorieController.text,
      prix: double.parse(_prixController.text),
      photo: imageURL,
      quantite: int.parse(_quatiteController.text),
    ));
    setState(() {
      _loading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Ajouter produit'),
      content: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: _marqueController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Marque',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            controller: _categorieController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Categorie',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            controller: _designationController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Designation',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            controller: _prixController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Prix',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            controller: _quatiteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Quatite',
            ),
          ),
          const SizedBox(height: 10),
          const Text("Image", style: TextStyle(fontSize: 17)),
          const SizedBox(height: 5),
          _selectedImage != null
              ? Image.file(_selectedImage!)
              : IconButton(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                ),
        ],
      ),
      actions: [
        _loading
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel),
                  ),
                  TextButton(
                    onPressed: _addProduit,
                    child: const Icon(Icons.add_box),
                  )
                ],
              ),
      ],
    );
  }
}

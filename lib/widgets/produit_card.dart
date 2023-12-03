import 'package:atelier4_a_almai_iirg6/models/produit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProduitCard extends StatelessWidget {
  final Produit _produit;
  final TextStyle _cardTextStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final Function(Produit) _deleteProduit;
  const ProduitCard({
    super.key,
    required Produit produit,
    required Function(Produit) deleteProduit,
  })  : _produit = produit,
        _deleteProduit = deleteProduit;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (context) {
                _deleteProduit(_produit);
              },
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Image.network(
                _produit.photo,
                fit: BoxFit.fill,
                height: 200,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return child;
                },
              ),
              Text(_produit.designation, style: _cardTextStyle),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(_produit.categorie, style: _cardTextStyle),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(_produit.marque, style: _cardTextStyle),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_produit.prix.toString(), style: _cardTextStyle),
                        const Icon(Icons.attach_money),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_produit.quantite.toString(),
                            style: _cardTextStyle),
                        const Icon(Icons.production_quantity_limits),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

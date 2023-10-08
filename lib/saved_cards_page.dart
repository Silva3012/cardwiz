import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'user_credit_card.dart';
import 'package:path/path.dart';

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({Key? key}) : super(key: key);

  @override
  _SavedCardsPageState createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  List<UserCreditCard> savedCards = [];

  @override
  void initState() {
    super.initState();
    fetchSavedCards();
  }

  Future<void> fetchSavedCards() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), "credit_card.db"),
    );

    final List<Map<String, dynamic>> cardMaps = await database.query("credit_cards");

    setState(() {
      savedCards = cardMaps.map((cardMap) => UserCreditCard.fromMap(cardMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Cards"),
      ),
      body: ListView.builder(
        itemCount: savedCards.length,
        itemBuilder: (context, index) {
          final UserCreditCard card = savedCards[index];
          return ListTile(
            title: Text(card.name ?? ""),
            subtitle: Text(card.number ?? ""),
            trailing: Text('Expiry: ${card.month}/${card.year}'),
            leading: const Icon(Icons.credit_card),
          );
        },
      )
    );
  }
}
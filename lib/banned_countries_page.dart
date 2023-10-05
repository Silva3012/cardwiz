import 'package:flutter/material.dart';
import 'countries.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Banned countries as a StatefulWidget
class BannedCountriesPage extends StatefulWidget {
  const BannedCountriesPage({super.key});

  @override
  State<BannedCountriesPage> createState() => _BannedCountriesPageState();
}

class _BannedCountriesPageState extends State<BannedCountriesPage>{
  List<String> bannedCountries = [];
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries().then((fetchedCountries) {
      setState(() {
        countries = fetchedCountries;
      });
    });
    loadBannedCountries();
  }

  Future<void> loadBannedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bannedCountries = prefs.getStringList("bannedCountries") ?? [];
    });
  }

  // Add to banned list
  void addCountyToBannedList(Country country) async {
    setState(() {
      bannedCountries.add(country.name);
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("bannedCountries", bannedCountries);
  }

  // Remove from banned list
  void removeCountryFromBannedList(Country country) async {
    setState(() {
      bannedCountries.remove(country.name);
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("bannedCountries", bannedCountries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banned Countries"),
      ),
      body: Column(
        children: [
          DropdownButton<Country>(
              hint: const Text("Select a country"),
              value: null,
              items: countries.map((Country country) {
                return DropdownMenuItem<Country>(
                    value: country,
                    child: Text(country.name),
                );
              }).toList(),
              onChanged: (Country? selectedCountry) {
                if (selectedCountry != null) {
                  if(bannedCountries.contains(selectedCountry.name)) {
                  removeCountryFromBannedList(selectedCountry);
                  } else {
                    addCountyToBannedList(selectedCountry);
                  }
                }
              },
          ),
          const SizedBox(height: 16),
          const Text("Banned Countries"),
          ListView.builder(
              shrinkWrap: true,
              itemCount: bannedCountries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(bannedCountries[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        bannedCountries.removeAt(index);
                      });
                    }
                  ),
                );
              }
          )
        ],
      )
    );
  }

}

/*
Storing with shared_preferences
https://stackoverflow.com/questions/62657223/how-to-save-listliststring-with-sharedpreferences-in-flutter

https://blog.logrocket.com/using-sharedpreferences-in-flutter-to-store-data-locally/
 */
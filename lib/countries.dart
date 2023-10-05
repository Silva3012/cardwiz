import 'dart:convert';
import 'package:http/http.dart' as http;

// Network request
Future<List<Country>> fetchCountries() async {
  final response = await http.get(Uri.parse("https://restcountries.com/v3.1/all"));

  print('Status code: ${response.statusCode}');

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    // List of Country objects
    final List<Country> countries = jsonData.map((json) {
      return Country(
        name: json['name']['common'],
        code: json["cca2"],
      );
    }).toList();

    // Sort countries alphabetically
    countries.sort((a, b) => a.name.compareTo(b.name));

    print("Fetched countries: ${countries.map((country) => country.name).join(', ')}"); // Print the fetched data
    return countries;
  } else {
    throw Exception('Failed to load countries');
  }
}
// Class to represent country data
class Country {
  final String name;
  final String code;

  const Country({required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['cca2'],
    );
  }
}

// A config mechanism to define and update the list of banned countries.
class Configuration {
  List<String> bannedCountries = [];

  void addBannedCountry(String country) {
    bannedCountries.add(country);
  }

  void removeBannedCountry(String country) {
    bannedCountries.remove(country);
  }
}

Configuration config = Configuration();

// A function that check if a country is banned
bool isCountryBanned(String issuingCountry) {
  return config.bannedCountries.contains(issuingCountry);
}

/*
Fetching data
https://docs.flutter.dev/cookbook/networking/fetch-data
 */
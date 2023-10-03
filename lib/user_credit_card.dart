import 'package:flutter/material.dart';

// Enumeration of the card types we want to support
enum CardType {
  Visa,
  Maestro,
  Mastercard,
  Others, // For other cards
  Invalid // For invalid card
}

// A class that will hold the credit card fields
class UserCreditCard {
  CardType? type;
  String? number;
  String? name;
  int? month;
  int? year;
  int? cvv;

  // Shorthand initialization using this.
  UserCreditCard({this.type, this.number, this.name, this.month, this.year, this.cvv});

  @override
  String toString() {
    return "[Type: $type, Number: $number, Name: $name, Month: $month, Year: $year, CVV: $cvv]";
  }
}

// Validation functions
// Validate card number using the Luhn Algorithm
String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your card number";
    }

    // Removing any non-digit characters from the input
    value = cleanedNumber(value);

    if (value.length < 8) {
      return "Invalid Card";
    }

    int sum = 0;
    for (var i = 0; i < value.length; i++) {
      // Get the digits in reverse order
      int digit = int.parse(value[value.length - i -1]);

      // Multiply every 2nd number with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      // If the digit is greater than 9, then subtract 9 from it
      sum += digit > 9 ? (digit - 9) : digit;
    }

    // If the sum is a multiple of 10 then the card number is valid
    if (sum % 10 == 0) {
      return null;
    }

    // If the cad number is not valid then return an error
    return "Invalid Card";
}

// Function to validate CVV
String? validateCVV(String? value) {
  // Is the CVV null or empty
  if (value == null || value.isEmpty) {
    return "Please enter your CVV";
  }
  // CVV should be 3 digits
  if (value.length < 3 || value.length > 4) {
    return "Your CVV is invalid";
  }
  return null; // Return null if CVV is valid
}

// Function that removes any non-digit characters with regex
String cleanedNumber(String text) {
  // Match any character that is not a digit
  RegExp regExp = RegExp(r"[^0-9]");

  // Replace all non-digit characters with an empty string
  return text.replaceAll(regExp, "");
}



/*
Reference for this project: https://medium.com/flutter-community/validating-and-formatting-payment-card-text-fields-in-flutter-bebe12bc9c60
Classes ref: https://dart.dev/language/classes
Constructor ref: https://dart.dev/language/constructors
Enums ref: https://dart.dev/language/enums
Luhn Algorithm: https://www.geeksforgeeks.org/luhn-algorithm/ and https://www.youtube.com/watch?v=PNXXqzU4YnM
Regex: https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
Regex: https://dart.dev/tools/linter-rules/valid_regexps
 */
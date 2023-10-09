
// Enumeration of the card types we want to support

enum CardType {
  Visa,
  Maestro,
  Mastercard,
  Others,
  Invalid // For invalid card
}

// A class that will hold the credit card fields
class UserCreditCard {
  int? id;
  CardType? type;
  String? number;
  String? name;
  int? month;
  int? year;
  int? cvv;
  String? selectedCountry;

  // Shorthand initialization using this.
  UserCreditCard({this.id, this.type, this.number, this.name, this.month, this.year, this.cvv, this.selectedCountry});

  // Converting to a map before storing in the SQLite DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type?.toString(),
      "number": number,
      "name": name,
      "month": month,
      "year": year,
      "cvv": cvv,
      "selectedCountry": selectedCountry,
    };
  }

  // Create a UserCreditCard from a map retrieved from the DB
  factory UserCreditCard.fromMap(Map<String, dynamic> map) {
    return UserCreditCard(
      id: map["id"],
      type: map["type"] != null ? CardType.values.firstWhere((e) => e.toString() == map["type"]) : null,
      number: map["number"],
      name: map["name"],
      month: map["month"],
      year: map["year"],
      cvv: map["cvv"],
      selectedCountry: map["selectedCountry"],
    );
  }

  // Redact the card number
  static String redactCardNumber(String? cardNumber) {
    if (cardNumber == null || cardNumber.length < 4) {
      return cardNumber ?? '';
    }
    return cardNumber.replaceRange(0, cardNumber.length - 4, "**** **** **** ");
  }

  @override
  String toString() {
    return "[ID: $id, Type: $type, Number: $number, Name: $name, Month: $month, Year: $year, CVV: $cvv, Issuing Country: $selectedCountry"
        "]";
  }
}

// Validation functions
String? validateName (String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter the name on the Card";
  }
  return null;
}
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

// Function to validate the expiry date
String? validateExpiryDate(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter the Expiry date";
  }

  int year;
  int month;

  // The value should contain a forward slash if the month and year has been entered
  if (value.contains(RegExp(r'(/)'))) {
    var splitValue = value.split(RegExp(r'(/)'));

    // The value before the slash is the month and the value after the slash is the year
    month = int.parse(splitValue[0]);
    year = int.parse(splitValue[1]);
  } else {
    // Only month was entered
    month = int.parse(value.substring(0, (value.length)));
    year = -1;
  }

  if ((month < 1) || (month > 12)) {
    // Valid month is between 1 and 12 (Jan and Dec respectively)
    return "Invalid expiry month";
  }

  var fourDigitsYear = yearToFourDigits(year);

  if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
    // A valid year should be between 1 and 2099
    return "Invalid expiry year";
  }

  if (!isDateExpired(month, year)) {
    return "The card has expired";
  }
  return null;
}

// Function to convert two-digit year to four-digit if necessary
int yearToFourDigits(int year) {
  if (year < 100 && year >= 0) {
    final now = DateTime.now();
    final currentYear = now.year.toString();
    final prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

// isDateExpired function
bool isDateExpired(int month, int year) {
  return isDateNotExpired(year, month);
}

// isDateNotExpired function
// Not expired if both year and month has not passed
bool isDateNotExpired(int year, int month) {
  return !isYearPassed(year) && !isMonthPassed(year, month);
}

// isYearPassed function
// Year has passed if the current year is more that the card year
bool isYearPassed(int year) {
  int fourDigitsYear = yearToFourDigits(year);
  final now = DateTime.now();
  return fourDigitsYear < now.year;
}

// isMonthPassed function
// Month passed if year is in the past and also card month is more than current month
bool isMonthPassed(int year, int month) {
  final now = DateTime.now();
  return isYearPassed(year) || yearToFourDigits(year) == now.year && (month < now.month + 1);
}

/*
getCardExpiryDate by splitting the date and using index 0 of the split as the month
and index 1 as the year
 */
List<int> getCardExpiryDate(String value) {
  final split = value.split(RegExp(r'(/)'));
  return [int.parse(split[0]), int.parse(split[1])];
}


// Function that removes any non-digit characters with regex
String cleanedNumber(String text) {
  // Match any character that is not a digit
  RegExp regExp = RegExp(r"[^0-9]");

  // Replace all non-digit characters with an empty string
  return text.replaceAll(regExp, "");
}

CardType getCreditCardTypeFromNumbers(String numbers) {
  CardType cardType;
  if(numbers.startsWith(RegExp(r'4'))) {
    cardType = CardType.Visa;
  } else if (numbers.startsWith(RegExp(r'(5018|5020|5038|5893|6304|6759|6761|6762|6763)'))){
    cardType = CardType.Maestro;
  } else if (numbers.startsWith(RegExp(r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))){
    cardType = CardType.Mastercard;
  } else if (numbers.length <= 8) {
    cardType = CardType.Others;
  } else {
    cardType = CardType.Invalid;
  }
  return cardType;
}



/*
Reference for this project: https://medium.com/flutter-community/validating-and-formatting-payment-card-text-fields-in-flutter-bebe12bc9c60
Classes ref: https://dart.dev/language/classes
Constructor ref: https://dart.dev/language/constructors
Enums ref: https://dart.dev/language/enums
Luhn Algorithm: https://www.geeksforgeeks.org/luhn-algorithm/ and https://www.youtube.com/watch?v=PNXXqzU4YnM
Regex: https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
Regex:
https://dart.dev/tools/linter-rules/valid_regexps
https://www.regular-expressions.info/creditcard.html
https://regex101.com/library/uW8mC3?filterFlavors=java&orderBy=MOST_RECENT&page=3&search=

DateTime class: https://api.flutter.dev/flutter/dart-core/DateTime-class.html

Card Types by numbers:
https://en.wikipedia.org/wiki/Payment_card_number#cite_note-mastercard-rules-16

startsWith method
https://api.flutter.dev/flutter/dart-core/String/startsWith.html

Persisting data with SQLite
https://docs.flutter.dev/cookbook/persistence/sqlite

Replace Range
https://api.flutter.dev/flutter/dart-core/List/replaceRange.html#:~:text=replaceRange%20abstract%20method,-void%20replaceRange(&text=Removes%20the%20objects%20in%20the,elements%20of%20replacements%20at%20start%20.&text=The%20provided%20range%2C%20given%20by,end%20%3D%3D%20start%20)%20is%20valid.
 */
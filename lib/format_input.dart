import 'package:flutter/services.dart';

// A custom TextInputFormatter to format credit card numbers
class CreditCardNumberFormatter extends TextInputFormatter {
  final String sample;
  final String separator;

  CreditCardNumberFormatter({
    required this.sample,
    required this.separator,
});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;
        if (newValue.text.length < sample.length && sample[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(offset: newValue.selection.end + 1,),
          );
        }
      }
    }
    return newValue;
  }
}

// A custom TextInputFormatter to format the expiry date
class CardDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = "";

    for (int i = 0; i < newValueString.length; i++) {
      if(newValueString[i] != "/") valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'/'));
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newValueString.length && !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}

/*
References
Input Formatting
https://api.flutter.dev/flutter/services/TextInputFormatter-class.html
https://appvesto.medium.com/flutter-formatting-textfield-with-textinputformatter-c73ee2167514
https://stackoverflow.com/questions/67307908/flutter-expiry-date-text-field

formatEditUpdate method
https://api.flutter.dev/flutter/services/LengthLimitingTextInputFormatter/formatEditUpdate.html

About assert
https://stackoverflow.com/questions/56537718/what-assert-do-in-dart

Required
https://stackoverflow.com/questions/54181838/flutter-required-keyword
 */
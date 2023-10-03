import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fomart_input.dart';
import 'package:cardwiz/user_credit_card.dart';

// Starting point of the app
void main() => runApp(const MyApp());

// CardWiz class represents the main application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Base widget of the app
    return MaterialApp(
      title: "CardWiz",
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: Scaffold(
        // Add the app bar at the top
        appBar: AppBar(
          title: const Text("Card Wiz"),
        ),
        // We will add some padding on the body of the Scaffold widget
        body: const Padding(
          padding: EdgeInsets.all(9.0),
          child: CreditCardDetailsForm(),
        )
      ),
    );
  }
}



// CreditCardDetailsForm will be a StatefulWidget, so that it can maintain state
class CreditCardDetailsForm extends StatefulWidget {
  const CreditCardDetailsForm({super.key});

  @override
  State<CreditCardDetailsForm> createState() => _CreditCardDetailsFormState();
}

// The state of CreditCardDetailsForm is _CreditCardDetailsFormState
class _CreditCardDetailsFormState extends State<CreditCardDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _creditCard = UserCreditCard();
  var numberController = TextEditingController();
  var _autoValidateMode = AutovalidateMode.disabled;

  // Initialize the controller and pass a function
  void initialState() {
    super.initState();
    _creditCard.type = CardType.Others;
    numberController.addListener(_getCreditCardTypeFromNumbers);
  }

  @override
  Widget build(BuildContext context) {
    // Form widget that creates a form
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TextFormField for the Card Name input.
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name on the Card",
              hintText: "Name",
            ),
            // Save users input in an object
            onSaved: (String? value) {
              _creditCard.name = value;
            },
            keyboardType: TextInputType.text,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please enter the name on the Card";
              }
              return null;
            },
          ),
          // TextFormField for the Card Number input.
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Card Number",
                hintText: "Enter you card number",
            ),
            inputFormatters: [
              CreditCardNumberFormatter(
                sample: "xxxx-xxxx-xxxx-xxxx",
                separator: "-",
              )
            ],
            controller: numberController,
            validator: validateCardNumber,
            keyboardType: TextInputType.number,
            onSaved: (String? value) {
              print("onSaved = $value");
              print("Num controller has = ${numberController.text}");
              _creditCard.number = cleanedNumber(value!);
            },

          ),
          // TextFormField for the CVV.
          TextFormField(
            decoration: const InputDecoration(
                labelText: "CVV",
                hintText: "CVV",
            ),
            keyboardType: TextInputType.number,
            validator: validateCVV,
              onSaved: (value) {
                _creditCard.cvv = int.parse(value!);
              }
          ),
          // TextFormField for the Issuing country.
          // TODO: Issuing country will change to a dropdown of pre-populated countries
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Country",
                hintText: "Issuing Country",
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your issuing country';
              }
              return null;
            },
          ),
          // TextFormField for the Expiry Date.
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Expiry Date",
                hintText: "MM/YY",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              CardDateFormatter()
            ],
            keyboardType: TextInputType.number,
            validator: validateExpiryDate,
            onSaved: (value) {
              List<int> expiryDate = getCardExpiryDate(value!);
              _creditCard.month = expiryDate[0];
              _creditCard.year = expiryDate[1];
            },
          ),
          // Validate Button
          Container(
            alignment: Alignment.center,
            child: _submitButton(),
          )
        ],
      )
    );
  }

  @override
  // Clean up the controller once Widget is removed from the Widget tree
  void dispose() {
    numberController.removeListener(_getCreditCardTypeFromNumbers);
    numberController.dispose();
    super.dispose();
  }

  // This function uses getCreditCardTypeFromNumbers to determine the card issuer from the number already entered
  void _getCreditCardTypeFromNumbers() {
    String numbers = cleanedNumber(numberController.text);
    CardType cardType = getCreditCardTypeFromNumbers(numbers);
    setState(() {
      _creditCard.type = cardType;
    });
  }

  // This function will be called when the submit button has been pressed to validate inputs
  void _validateCardInformation() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always; // Validate on every change
      });
      _showSnackBar("Please fix the errors in red before submitting.");

    } else {
      form.save();
      // TODO on local storage
      _showSnackBar("Credit has been validated");
      // Log the credit card class
      print("Credit Card Details: $_creditCard");
    }
  }

  void _showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 3),
    ));
  }

  Widget _submitButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
          onPressed: _validateCardInformation,
          child: const Text("Validate"));
    } else {
      return ElevatedButton(
          onPressed: _validateCardInformation,
          child: const Text("Validate"));
    }
  }

}



/*
About payment card numbers: https://en.wikipedia.org/wiki/Payment_card_number

Reference for the card details implementation: https://api.flutter.dev/flutter/widgets/Form-class.html

Some styling references
EdgeInsets: https://api.flutter.dev/flutter/painting/EdgeInsets-class.html

Why do we use the dispose method
https://stackoverflow.com/questions/59558604/why-do-we-use-the-dispose-method-in-flutter-dart-code

Platform class
https://api.flutter.dev/flutter/package-platform_platform/Platform-class.html

 */
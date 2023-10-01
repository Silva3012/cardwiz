// Flutter Material package
import 'package:flutter/material.dart';

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
      debugShowCheckedModeBanner: false,
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

  @override
  Widget build(BuildContext context) {
    // Form widget that creates a form
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TextFormField for the Card Number input.
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Card Number'
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your card number';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'CVV'
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your CVV';
              }
              return null;
            },
          ),
          // TODO: Issuing country will change to a dropdown of pre-populated countries
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Issuing Country'
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your issuing country';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Expiry Date'
            ),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Expiry date';
              }
              return null;
            },
          ),
          // Padding the submit button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if(_formKey.currentState!.validate()) {
                  //If the form is valid, show a Snackbar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully validated")));
                }
              },
              child: const Text("Submit")
            )
          )
        ],
      )
    );
  }


}

// Reference for the card details implementation: https://api.flutter.dev/flutter/widgets/Form-class.html

/*
Some styling references
EdgeInsets: https://api.flutter.dev/flutter/painting/EdgeInsets-class.html
 */
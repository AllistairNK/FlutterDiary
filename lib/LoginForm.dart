import 'package:flutter/material.dart';
import 'package:testing/main.dart';



class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16.0),
          child: TextFormField(
          decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter valid email id as abc@gmail.com'),
          validator: (value) {
          if (value != null && value.isEmpty) {
          return "* Required";
          } else if (value != null && value.length < 6) {
          return "Password should be atleast 6 characters";
          } else if (value != null && value.length > 15) {
          return "Password should not be greater than 15 characters";
          } else
          return null;
          },
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
          child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter secure password'),
          validator: (value) {
          if (value != null && value.isEmpty) {
          return "* Required";
          } else if (value != null && value.length < 6) {
          return "Password should be atleast 6 characters";
          } else if (value != null && value.length > 15) {
          return "Password should not be greater than 15 characters";
          } else
          return null;
          },
          ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 16.0),
          child: ElevatedButton(
          onPressed: () {
          if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
          Navigator.pushNamed(context, '/');
          isLoggedIn = true;
          }
 
          },
          child: Text('Submit'),
          ),
          ),
        ],
      ),
    );
  }
}
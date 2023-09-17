import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:brew_crew/services/auth.dart';

import '../../shared/constants.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: "Sign In to Brew Crew".text.make(),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: const Icon(
                  Icons.person_add_outlined,
                  color: Colors.white,
              ),
              label: "Register".text.color(Vx.white).make(),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                keyboardType: TextInputType.emailAddress,
                decoration: textInputDecoration,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (val) => val!.length < 6 ? 'Enter a Password of length 6 or more' : null,
                decoration: textInputDecoration.copyWith(hintText: "Enter Password", label: const Text("Password")),
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate())
                      {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInEmailPassword(email, password);
                        if(result == null)
                        {
                          setState(() {
                            error = 'Enter valid Email or Password';
                            loading = false;
                          });
                        }
                      }
                  },
                  child: "Sign In".text.make(),
              ),
              const SizedBox(height: 20),
              error.text.color(Colors.red).make()
            ]
          )
        ),
      ),
    );
  }
}

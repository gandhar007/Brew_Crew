import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // Form Values
  String _currentName = "";
  String _currentSugars = "0";
  int _currentStrength = 100;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  "Update Your Brew Settings".text.size(18).make(),
                  const SizedBox(height: 20),
                  TextFormField(
                      initialValue: userData?.name,
                      decoration: textInputDecoration.copyWith(
                          label: "Name".text.make(), hintText: "Enter Name"),
                      validator: (val) =>
                      val!.isEmpty
                          ? "Please Enter a Name"
                          : null,
                      onChanged: (val) =>
                          setState(() {
                            _currentName = val;
                          })
                  ),
                  const SizedBox(height: 20),

                  // Dropdown
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 2
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.pinkAccent,
                                width: 2
                            )
                        ),
                        fillColor: Vx.white,
                        filled: true,
                      ),
                      value: _currentSugars == '' ? sugars[0] : _currentSugars,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text("$sugar Sugars"),
                        );
                      }).toList(),
                      onChanged: (val) {
                        _currentSugars = val!;
                      }
                  ),
                  const SizedBox(height: 20),

                  //Slider
                  Slider(
                    activeColor: Colors.brown[_currentStrength],
                    inactiveColor: Colors.brown[_currentStrength],
                    min: 100,
                    max: 900,
                    divisions: 8,
                    value: (_currentStrength).toDouble(),
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.round();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.pinkAccent)
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars,
                            _currentName,
                            _currentStrength
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: "Update".text.color(Vx.white).make()
                  )
                ],
              ),
            );
          }
          else {
            return const Loading();
          }
        }
    );
  }
}

import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import '../../models/brew.dart';
import 'brew_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(
          backgroundColor: Colors.brown[50],
          context: context,
          builder: (context) {
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: const SettingsForm()
            );
          }
      );
    }

    final AuthService _auth = AuthService();

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService(uid: '').brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: "Brew Crew".text.make(),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {_showSettingsPanel();},
              icon: const Icon(
                Icons.settings,
                color: Vx.white,
              ),
              label: "Settings".text.color(Vx.white).make(),
            ),
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                label: "Logout".text.color(Vx.white).make(),
                icon: const Icon(
                  Icons.logout,
                  color: Vx.white,
                )
            ),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/coffee_bg.png')
              )
            ),
            child: BrewList()
        ),
      ),
    );
  }
}

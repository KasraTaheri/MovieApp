import 'package:flutter/material.dart';
import 'package:movie_app/services/authentication.dart';

class MorePage extends StatefulWidget {
  MorePage({Key key, this.auth, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final BaseAuth auth;

  @override
  _MorePageState createState() => new _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Friends'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: _signOut(),
          ),
        ],
      ),
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}

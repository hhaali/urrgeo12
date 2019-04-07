import 'package:flutter/material.dart';
import 'package:urrgeo12/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Pages
import 'package:urrgeo12/Setup/about.dart';

class Home extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  const Home({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isEmailVerified = false;
  FirebaseUser _user;
  String _username = 'no user login';
  String _email = 'no user email';
  String _photourl = 'no user photo';

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
    _getUserInfo();
  }

  void _getUserInfo() async {
    _user = await widget.auth.getCurrentUser();

    _username = (_user.displayName == null
        ? 'no user login'
        : _user.displayName.split('|')[0]);
    _email = _user.email;
    _photourl = (_user.photoUrl == null ? '' : _user.photoUrl);
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the homePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Urrgeo Home'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              //child: new Text('Logout',
              //    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      drawer: new Drawer(
          child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(_username),
            accountEmail: new Text(_email),
            currentAccountPicture: new CircleAvatar(
            backgroundImage: NetworkImage('test'),
              backgroundColor: Colors.yellow,
            ),
          ),
          ListTile(
            title: Text('About Urrgeo'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
            },
          )
        ],
      )),
    );
  }
}

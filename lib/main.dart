import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        '/': (_) => MyHomePage(title: 'First Screen'),
        '/second': (_) => SecondScreen(title: 'Second Screen',)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _layoutBody() // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _layoutBody() {
    return Center(
      child: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              TextFormField(
                controller: emailInputController,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: passwordInputController,
                decoration: const InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 24.0,),
              Center(
                child: RaisedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    var email = emailInputController.text;
                    var password = passwordInputController.text;

                    // ToDo ログイン要求を書く
                    return _signInWithEmailAndPasswd(email, password)
                        .then(
                          (_) => Navigator.of(context).pushNamed('/second'),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _signInWithEmailAndPasswd(String email, String passwd) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: passwd
    );

    print("User id is ${user.uid}");

    return user;
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _SecondScreenState createState() => _SecondScreenState();
  
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Logout'),
          onPressed: () {
            return FirebaseAuth.instance.signOut().then((_) => _signOutAndRetrun(context));
          },
        ),
      ),
    );
  }
  
  void _signOutAndRetrun(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => MyHomePage(title: 'First Screen',)), (_) => false);
    return null;
  }
}
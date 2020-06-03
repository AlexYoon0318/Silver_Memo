import 'package:flutter/material.dart';
import 'package:biometric/biometric.dart';
import 'package:flutter/services.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Biometric biometric = Biometric();
  String _hintPass = "Password";
  String _errorMessage = "틀린 지문입니다.";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _initializeBiometric();
    });
  }

  Future<void> _initializeBiometric() async {
    String errorMessage = "";
    String errorCode = "";
    bool authStatus = false;
    bool authAvailable;

    try {
      authAvailable = await biometric.biometricAvailable();
    } on PlatformException catch (e) {
      print(e);
    }

    if (authAvailable) {
      setState(() {
        _hintPass = "Password or Biometric";
      });

      try {
        authStatus = await biometric.biometricAuthenticate(keepAlive: true);
      } on PlatformException catch (e) {
        errorMessage = e.message.toString();
        errorCode = e.message.toString();
      }
      if (!mounted) return;

      if (authStatus) {
        Navigator.of(context).pushReplacementNamed("/notes_list");
      } else {
        if (errorCode != "BIO-CANCEL" && errorCode != "BIO-PROGRESS") {
          setState(() {
            _errorMessage = errorMessage;
            _initializeBiometric();
          });
        }
      }
    }
  }

  Future<void> _cancelAuthenticate() async {
    try {
      await biometric.biometricCancel();
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(context)
    );
  }


  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(16.0),),
              RaisedButton(
                  child: Text('지문을 인식해주세요.', style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    _cancelAuthenticate();
                  }
              ),
              SizedBox(height: 30.0,),
              Text(_errorMessage, style: TextStyle(color: Colors.red),),

            ]),
      ),
    );
  }
}
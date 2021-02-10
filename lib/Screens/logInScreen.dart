import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/auth.dart';
import '../assets/constants.dart';

import 'package:flutter/material.dart';
import '../assets/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  var _isLogin = true;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1,
          colors: [secondaryColor, primaryColor],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue[900], width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                width: screenWidth - 50,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                          filled: true,
                        ),
                      ),
                      if (!_isLogin) SizedBox(height: 10),
                      if (!_isLogin)
                        TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            icon: Icon(Icons.lock),
                            labelText: 'Password',
                            filled: true,
                          ),
                        ),
                      SizedBox(height: 10),
                      RaisedButton(
                          child: Text(!_isLogin ? 'Sign Up' : 'Login'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          color: Colors.blue,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              try {
                                await context.read<Auth>().signIn(_email, _password);
                              } on AuthException {} catch (e) {
                                //TODO implement error logic
                              }
                            }
                          }),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Login',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

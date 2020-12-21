import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Moels/HttpExcepytion.dart';
import 'package:shop_app_aftereid/providers/Auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                List: [
                  Colors.purple[100],
                  Colors.blueAccent.withOpacity(0.5),
                  Colors.blue[300].withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                //stops: [0, 1, 2],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Text(
                        "Let's Shop",
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Flexible(
                  //   child: Container(
                  //     margin: EdgeInsets.only(bottom: 20.0),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                  //     transform: Matrix4.rotationZ(-8 * pi / 180)
                  //       ..translate(-10.0),
                  //     // ..translate(-10.0),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: Colors.deepOrange.shade900,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           blurRadius: 8,
                  //           color: Colors.black26,
                  //           offset: Offset(0, 2),
                  //         )
                  //       ],
                  //     ),
                  //     child: Text(
                  //       'MyShop',
                  //       style: TextStyle(
                  //         color: Theme.of(context).accentTextTheme.title.color,
                  //         fontSize: 50,
                  //         fontFamily: 'Anton',
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  // const AuthCard({
  //   Key key,
  // }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      // Log user in
      await Provider.of<Auth>(context, listen: false)
          .logIn(_authData['email'], _authData['password']);
    } else {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      } on HttpException catch (error) {
        var errorMessage = 'Error Occured';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage =
              'This email is Already present. Please Try another email to SignUp';
          showErrorMessage(errorMessage, context);
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This E-Mail is Invalid';
          showErrorMessage(errorMessage, context);
        }
        if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'ThE Password is too weak';
          showErrorMessage(errorMessage, context);
        }
      } catch (error) {
        print(error.toString());
        var errorMessage = 'It Might be a Network Issue';
        showErrorMessage(errorMessage, context);
      }

      // Sign user up
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void showErrorMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 25,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Text('Error'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25),
                  child: TextFormField(
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),

                        // contentPadding: EdgeInsets.all(10),
                        // helperText: 'Title',
                        // icon: Icon(Icons.title),
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.blue))),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.blue,
                      ),

                      // contentPadding: EdgeInsets.all(10),
                      // helperText: 'Title',
                      // icon: Icon(Icons.title),
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.blue))),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                _authMode == AuthMode.Signup
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          //  decoration:

                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              filled: true,
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(
                                Icons.confirmation_number,
                                color: Colors.blue,
                              ),

                              // contentPadding: EdgeInsets.all(10),
                              // helperText: 'Title',
                              // icon: Icon(Icons.title),
                              fillColor: Colors.grey[100],
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.blue))),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      )
                    : SizedBox(
                        height: 20,
                      ),
                (_isLoading)
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

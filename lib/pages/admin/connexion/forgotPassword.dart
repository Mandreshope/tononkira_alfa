import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/authBloc.dart';
import 'package:tononkira_alfa/tools/validator.dart';
import 'package:tononkira_alfa/widgets/logo.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email = "";

  @override
  Widget build(BuildContext context) {
    final AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back), 
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          backgroundColor: Colors.transparent,
        ), 
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80.0),
              Container(
                width: double.infinity,
                child: Center(
                    child: Logo()
                )
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text("Tononkira ALFA", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ))),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (val) {
                  setState(() {
                    _email = val;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: "Adiresy mailaka",
                  prefixIcon: Icon(Icons.email, color: Colors.black,),
                  errorText: _email == "" ? null : isValidateEmail(_email) ? null : 'hamarino ny mailaka anao'
                ),
              ),
              SizedBox(height: 20.0),
              _authBloc.forgotPasswordLoader 
              ? Center(child: CircularProgressIndicator())
              : _email.trim() == ""
                ? RaisedButton(
                    color: Colors.grey[200],
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      child: Center(
                        child: Text("Handefa", style: TextStyle(fontWeight: FontWeight.bold,)),
                      )
                    ),
                    onPressed: () async {
                    },
                  )
                : RaisedButton(
                  color: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text("Handefa", style: TextStyle(fontWeight: FontWeight.bold,)),
                    )
                  ),
                  onPressed: () async {
                    try {
                      _authBloc.setforgotPasswordLoader = true;
                      await _authBloc.resetPassword(email:_email);
                      _authBloc.setforgotPasswordLoader = false;
                      await _buildAlertDialog("Nisy rohy iray hamerenana ny tenimiafinao nalefa any amin'ny $_email.");
                      Navigator.of(context).pop();
                    } catch (e) {
                      _authBloc.setforgotPasswordLoader = false;
                      String errorMessge;
                      switch (e.code) {
                        case 'ERROR_INVALID_EMAIL':
                          errorMessge = "Hamarino ny adiresy mailaka !";  
                          break;
                        case 'ERROR_USER_NOT_FOUND':
                          errorMessge = "Tsy misy kaonty mifandraika amin'ny adiresy mailaka nomena";  
                          break;
                        default:
                          errorMessge = e.message;
                      }
                      _buildErrorDialog(errorMessge);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future _buildAlertDialog(_message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Fampafantarina'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('ENY'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
  Future _buildErrorDialog(_message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Misy tsy fetezana'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('HIALA'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}
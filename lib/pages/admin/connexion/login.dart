import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/authBloc.dart';
import 'package:tononkira_alfa/pages/admin/connexion/forgotPassword.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';
import 'package:tononkira_alfa/tools/validator.dart';
import 'package:tononkira_alfa/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _password = "";
  String _email = "";
  bool _obscure = true;

  void _toggle() {
    setState(() {
      _obscure = !_obscure;
    });
  }
  
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              TextField(
                onChanged: (val) {
                  setState(() {
                    _password = val;
                  });
                },
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: !_obscure ? Icon(Icons.visibility, color: Colors.black) : Icon(Icons.visibility_off, color: Colors.black,),
                    onPressed: _toggle,
                  ),
                  labelText: "Tenimiafina",
                  prefixIcon: Icon(Icons.lock, color: Colors.black,),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                child: Text("Nanadino tenimiafina ?", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                onTap: () {
                  Navigator.push(
                    context,
                    CustomOffsetRoute(
                      builder: (_) => ForgotPassword(),
                    )
                  );
                },
              ),
              SizedBox(height: 20.0),
              _authBloc.status == Status.Authenticating
              ? Center(child: CircularProgressIndicator())
              : _email.trim() == "" || _password.trim() == ""
                ?  RaisedButton(
                    color: Colors.grey[200],
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      child: Center(
                        child: Text("Hiditra", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      child: Text("Hiditra", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ),
                  onPressed: () async {
                    _authBloc.signIn(_email, _password).then((messageCode) {
                      switch (messageCode) {
                        case "ERROR_WRONG_PASSWORD":
                          _buildErrorDialog('Hamarino ny tenimiafina !');
                          break;
                        case "ERROR_INVALID_EMAIL":
                            _buildErrorDialog('Hamarino ny adiresy mailaka !');
                          break;
                        case "ERROR_USER_DISABLED":
                          _buildErrorDialog("Tsy miasa io kaonty io");
                          break;
                        case "ERROR_USER_NOT_FOUND":
                          _buildErrorDialog("Tsy misy kaonty mifandraika amin'ny adiresy mailaka nomena, na voafafa io kaonty io.");
                          break;
                        case "ERROR_TOO_MANY_REQUESTS":
                          _buildErrorDialog("Fanandramana be loatra, avereno afaka fotoana fohy");
                          break;
                        case "ERROR_OPERATION_NOT_ALLOWED":
                          _buildErrorDialog("Tsy mandeha ny kaonty. Nisy rohy hampandehanana ny kaontinao nalefa tany aminy $_email."); 
                          break;
                        case "ERROR_NETWORK_REQUEST_FAILED":
                          _buildErrorDialog("Zahao ny fifandraisana amin'ny Internet!"); 
                          break;
                        default:
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
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
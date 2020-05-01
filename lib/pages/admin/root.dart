import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/authBloc.dart';
import 'package:tononkira_alfa/pages/admin/admin.dart';
import 'package:tononkira_alfa/pages/admin/connexion/login.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(
      builder: (context, user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Status.Unauthenticated:
            return LoginPage();
          case Status.Authenticating:
            return LoginPage();
          case Status.Authenticated:
            return AdminPage();
          default:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
  
}
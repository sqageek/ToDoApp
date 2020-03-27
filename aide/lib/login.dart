import 'package:flutter/material.dart';
import 'package:aide/auth.dart';

// As login page has to handle user input, it has to be stateful
class TODOLogin extends StatefulWidget {
  // Callback function that will be called on pressing the login button
  final onLogin;

  TODOLogin({@required this.onLogin});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<TODOLogin> {

  // Controllers for handling email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Authentication helper
  final auth = Authentication();

  // Function to authenticate, call callback to save the user and navigate
  // to next page

  void doLogin() async{
    final user = await auth.login(emailController.text, passwordController.text);
    if(user !=  null){
      // Calling callback function
      widget.onLogin(user);
      Navigator.pushReplacementNamed(context, '/list');
    } else{
      _showAuthFailedDialog();
    }
  }

  // Show error if login unsuccessfull
  void _showAuthFailedDialog(){
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context){
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Could not log in"),
          content: new Text('Double check your credentials and try again'),
          actions: <Widget>[
            // usually button at the bottom of the dialog
            new FlatButton(
                child: new Text('Close'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          // Align widgets in a vertical column
          child: Column(
            // Passing multiple widgets as children to column
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  )),
              RaisedButton(
                // Calling the callback with the supplied email and password
                onPressed: doLogin,
                child: Text('LOGIN'),
                color: ThemeData().primaryColor,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
          )),
    );
  }
}

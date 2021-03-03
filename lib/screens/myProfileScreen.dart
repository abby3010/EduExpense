import 'package:eduexpense/authentication/auth_service.dart';
import 'package:eduexpense/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<AuthService>(context).getCurrentUser();
    final user = authUser.currentUser();

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.account_circle_outlined),
          Text(" My profile"),
        ]),
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Theme.of(context).accentColor),
            clipper: GetClipper(),
          ),
          Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 20,
            child: Column(
              children: <Widget>[
                user.photoUrl == null
                    ? ClipOval(
                        child: Container(
                          color: Colors.pinkAccent,
                          height: 150.0,
                          width: 150.0,
                          child: Center(
                            child: Text(
                              user.displayName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                              image: user.photoUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.photoUrl),
                                      fit: BoxFit.cover)
                                  : null,
                              boxShadow: [
                                BoxShadow(blurRadius: 20.0, color: Colors.white)
                              ]),
                        ),
                      ),
                SizedBox(height: 10.0),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 90.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    onPressed: () {
                      try {
                        authUser.signOutUser();
                        print("SignOut Successful!");
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/", (Route<dynamic> route) => false);
                      } catch (e) {
                        print(e);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Logout Error"),
                              content: Text(
                                  "Some error occured!\nYou are still Signed In"),
                              actions: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: FlatButton(
                                    child: Text("Try Again"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Once you Logout, you won't be able to upload any notes. Although you can view notes uploaded by others.",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height / 4);
    path.lineTo(size.width + 200, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduexpense/utils/navdrawer.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          'JEE Notes Feedback Form',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Your reviews will help us to improve more. Openly address your suggestions or problems with this app, since we have kept this feedback system anonymous.",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    maxLines: 6,
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "Your Reviews:",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                // Feedback textField
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1, //Normal textInputField will be displayed
                  maxLines: 7,
                  controller: feedbackController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: Colors.grey[600]),
                      hintText: "Type in your text here...",
                      fillColor: Colors.grey[200]),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Text(
                      "Submit Feedback",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('Feedback')
                            .doc("Feedbacks")
                            .update({
                          "feedback": FieldValue.arrayUnion(
                              [feedbackController.text]),
                        })
                            .then(
                              (value) => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Submitted!"),
                                content: Text(
                                    "Thank you for your reviews. They are the true source of information for us to improve."),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/",
                                              (route) => false);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                            .catchError((error) =>
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error!"),
                                  content: Text(
                                      "There seem to occur some error while submitting your feedback"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Try Again'),
                                    ),
                                  ],
                                );
                              },
                            )
                        );
                      }
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copyright,
                      size: 20,
                    ),
                    Text(
                      " 2021 EduExpense",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinanceDataWidget extends StatefulWidget {
  @override
  _FinanceDataWidgetState createState() => _FinanceDataWidgetState();
}

class _FinanceDataWidgetState extends State<FinanceDataWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Finance Data").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          final goldData = documents[0].data();
          final newsData = documents[1].data();
          final niftyData = documents[2].data();
          final sensexData = documents[3].data();
          final silverData = documents[4].data();

          return Container(
            height: MediaQuery.of(context).size.height * 0.225,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                // Gold Card
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/gold.png",
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          goldData["gold_rate"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "10 Gram",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "Yesterday " + goldData["gold_rate_yesterday"],
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Change " + goldData["rate_change"],
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Gold",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                // Silver Card
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/silver.png",
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          silverData["silver_rate"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "10 Gram",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "Yesterday " + silverData["silver_rate_yesterday"],
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Change " + silverData["rate_change"],
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Silver",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                // Nifty Card
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/images/nifty.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "₹" + niftyData["nifty_value"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: niftyData["nifty_ispositive"]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          niftyData["change"] + "\n" + niftyData["pchange"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: niftyData["pchange_ispositive"]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sensex Card
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/sensex.jpg",
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "₹" + sensexData["sensex_value"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: sensexData["change_ispositive"]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          sensexData["change"] + "\n" + sensexData["pchange"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: niftyData["pchange_ispositive"]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Text("Error Fetching Finance Data");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

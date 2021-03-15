import 'package:eduexpense/screens/newsScreen.dart';
import 'package:eduexpense/utils/financeData.dart';
import 'package:eduexpense/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String hometext = "Hola Amigos!\nThe project is on!";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      // backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(
          'EduExpense',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // All the Financial Data in the top horizontal list comes from here!!!
            FinanceDataWidget(),

            // News Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Latest Finance News",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Finance Data")
                  .doc("news")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var newsDoc = snapshot.data.data();

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: newsDoc["news"].length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: newsDoc["news"][index]
                                                ["image_url"] !=
                                            null
                                        ? Image.network(
                                            newsDoc["news"][index]["image_url"],
                                            )
                                        : Image.asset("assets/images/news.png",
                                            )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                newsDoc["news"][index]["headline"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsScreen(
                                  url: newsDoc["news"][index]
                                  ["url"],
                                ),),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Sorry we could not fetch data!\nSome error occured",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Nothing Happens as of now
          setState(() {
            hometext = "Nothing happens as of now! xD";
          });
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Text("Building Results");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Random Notes")
          .doc("Random Notes Doc")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var doc = snapshot.data.data();
          final List fileNames = doc["file_names"];
          final List<String> recentSearch = [];
          final suggestionList = query.isEmpty
              ? recentSearch
              : fileNames
                  .where((element) =>
                      element.contains(RegExp(query, caseSensitive: false)))
                  .toList();
          return ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.insert_drive_file_rounded),
                  title: RichText(
                    text: TextSpan(
                      text: suggestionList[index],
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    recentSearch.add(suggestionList[index]);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ShowPDFScreen(
                    //       filename: mapList[index]["file_name"],
                    //       url: mapList[index]["url"],
                    //     ),
                    //   ),
                    // );
                  },
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
            "OOPS!\n Some error occured\nCheck your internet connection speed\nSorry for the inconvenience :(",
            textAlign: TextAlign.center,
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/screens/preview.dart';
import 'package:lms/service/database.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  User _user;
  String search;
  TextEditingController searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // functions
  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      _userName = userdoc.get('username');
    });
  }

  _initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Database()
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      duration: Duration(milliseconds: 1500),
      content: Text(message,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
    ));
  }

  _joinValueInGroup(
      String username, String courseId, String courseName, String role) async {
    bool value = await Database(uid: _user.uid).isUserJoined(
        courseId: courseId, courseName: courseName, username: username);
    setState(() {
      _isJoined = value;
    });
  }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                _userName,
                searchResultSnapshot.docs[index].get("courseId"),
                searchResultSnapshot.docs[index].get("courseName"),
                searchResultSnapshot.docs[index].get("tutor"),
              );
            })
        : Container();
  }

  Widget groupTile(
      String username, String courseId, String courseName, String role) {
    _joinValueInGroup(username, courseId, courseName, role);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.blueAccent,
          child: Text(courseName.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white))),
      title: Text(courseName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Tutor: $role"),
      trailing: InkWell(
        onTap: () async {
          await Database(uid: _user.uid).togglingGroupJoin(
              courseId: courseId, courseName: courseName, username: username);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Successfully joined the group "$courseName"');
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      Preview(courseId: courseId, courseName: courseName)));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Left the group "$courseName"');
          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black87,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Joined', style: TextStyle(color: Colors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Join', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black87,
          title: Text('Search',
              style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  color: Colors.grey[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value.toLowerCase();
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => searchController.clear(),
                            ),
                            hintText: "Search course..."),
                      )),

                      IconButton(
                          onPressed: () {
                            _initiateSearch();
                          },
                          icon: Icon(Icons.search, color: Colors.white))
                      // Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: BoxDecoration(
                      //         color: Colors.blueAccent,
                      //         borderRadius: BorderRadius.circular(40)),
                      //     child: Icon(Icons.search, color: Colors.white)))
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : groupList()
            ],
          ),
        ),
      ),
    );
  }
}

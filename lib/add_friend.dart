import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  //String currentUserEmail = "";

  getCurrentUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
    // final currentUserData = await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(currentUserId)
    //     .get();
    // setState(() {
    //   currentUserEmail = currentUserData.data()!['email'];
    // });
  }

  final TextEditingController _search = TextEditingController();
  bool isLoading = false;
  List _allResults = [];
  List _resultList = [];

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_search != "") {
      for (var clientSnapShot in _allResults) {
        var name = clientSnapShot['name'].toString().toLowerCase();
        var email = clientSnapShot['email'].toString().toLowerCase();
        if (name.contains(_search.text.toLowerCase()) ||
            email.contains(_search.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    setState(() {
      isLoading = true;
    });
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy('name')
        .get();
    setState(() {
      _allResults = data.docs;
      isLoading = false;
    });
    searchResultList();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _search.addListener(_onSearchChanged);
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Add Friends'),
          backgroundColor: Colors.grey[700],
        ),

        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _search,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                        contentPadding: const EdgeInsets.all(5),
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .where('userId', isNotEqualTo: currentUserId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final filteredDocs = snapshot.data!.docs
                            .where((doc) =>
                                doc['name']
                                    .toLowerCase()
                                    .contains(_search.text.toLowerCase()) ||
                                doc['email']
                                    .toLowerCase()
                                    .contains(_search.text.toLowerCase()))
                            .toList();

                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final friendId = filteredDocs[index].id;
                            final friendName = filteredDocs[index]['name'];
                            final friendEmail = filteredDocs[index]['email'];
                            final friendCnic = filteredDocs[index]['cnic'];
                            final friendCellno = filteredDocs[index]['callno'];
                            final friendGender = filteredDocs[index]['gender'];
                            // final friendPassword = filteredDocs[index]['password'];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: ListTile(
                                  title: Text(filteredDocs[index]['name']),
                                  subtitle: Text(filteredDocs[index]['email']),
                                  leading: const Icon(Icons.account_box),
                                  trailing: IconButton(
                                    iconSize: 30,
                                    color: Colors.blue[800],
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      if (currentUser != null) {
                                        final currentUserId = currentUser.uid;
                                        //Adding friend's data in our Friend's collection
                                        final friendRef = FirebaseFirestore
                                            .instance
                                            .collection('Users')
                                            .doc(currentUserId)
                                            .collection('Friends')
                                            .doc(friendId);
                                        final friendDoc = await friendRef.get();
                                        if (friendDoc.exists) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      '$friendName already exists in your Friend\'s List')));
                                        } else {
                                          // Add friend to Current User's Friend's collection

                                          friendRef.set({
                                            'userId': friendId,
                                            'name': friendName,
                                            'email': friendEmail,
                                            'cnic': friendCnic,
                                            'callno': friendCellno,
                                            'gender': friendGender,
                                          });

                                          // Add Current User to added friend's Friend's collection
                                          final currentUserRef =
                                              FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(currentUserId);

                                          final currentUserData =
                                              await currentUserRef.get();

                                          final addedUserRef = FirebaseFirestore
                                              .instance
                                              .collection('Users')
                                              .doc(friendId)
                                              .collection('Friends')
                                              .doc(currentUserId);

                                          await addedUserRef
                                              .set(currentUserData.data()!);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      '$friendName added in your Friend\'s List')));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

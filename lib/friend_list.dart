import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  Future<void> getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
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
    getCurrentUserId();
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
          title: const Text('My Friends'),
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
                        hintText: 'Search in your friend-list...',
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
                          .doc(currentUserId)
                          .collection('Friends')
                          .orderBy('name')
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: ListTile(
                                  title: Text(filteredDocs[index]['name']),
                                  subtitle: Text(filteredDocs[index]['email']),
                                  // leading: Icon(Icons.account_box),
                                  leading: IconButton(
                                    iconSize: 30,
                                    color: Colors.blue,
                                    icon: const Icon(Icons.message_outlined),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                currentUserId: currentUserId,
                                                friendId:
                                                    filteredDocs[index].id,
                                                friendName: filteredDocs[index]
                                                    ['name'])),
                                      );
                                    },
                                  ),
                                  trailing: IconButton(
                                    iconSize: 30,
                                    color: Colors.red,
                                    icon: const Icon(
                                        Icons.delete_forever_outlined),
                                    onPressed: () async {
                                      final firestoreInstance =
                                          FirebaseFirestore.instance;

                                      //Remove the user from your Friend's collection
                                      final myFriendsCollection =
                                          await firestoreInstance
                                              .collection('Users')
                                              .doc(currentUserId)
                                              .collection('Friends')
                                              .get();

                                      for (final friendDoc
                                          in myFriendsCollection.docs) {
                                        if (friendDoc.id == friendId) {
                                          await friendDoc.reference.delete();
                                          break;
                                        }
                                      }

                                      //Remove our details from deleted User's Friend's collection
                                      final userToBeRemovedFriendCollection =
                                          await firestoreInstance
                                              .collection('Users')
                                              .doc(friendId)
                                              .collection('Friends')
                                              .get();

                                      for (final friendDoc
                                          in userToBeRemovedFriendCollection
                                              .docs) {
                                        if (friendDoc.id == currentUserId) {
                                          await friendDoc.reference.delete();
                                          break;
                                        }
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('$friendName removed')));
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

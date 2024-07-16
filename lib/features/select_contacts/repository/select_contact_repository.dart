import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod/riverpod.dart';
import '../../../common/utils/utils.dart';
import '../../../models/user_model.dart';
import '../../chat/screens/chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
      (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint("Error fetching contacts: $e");
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(' ', '').replaceAll('-', '');

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String userPhoneNum = userData.phoneNumber.replaceAll(' ', '').replaceAll('-', '');

        if (selectedPhoneNum == userPhoneNum) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat':false,
              'profilePic':userData.profilePic,
            },
          );
          break;
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: "Error selecting contact: $e");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  @override
  ConsumerState<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts(List<Contact> contacts) {
    setState(() {
      _filteredContacts = contacts
          .where((contact) =>
          contact.displayName.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: !isSearching
            ? const Text('Select contact')
            : TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search contacts',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.watch(getContactsProvider).whenData((contacts) => _filterContacts(contacts));
          },
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.arrow_back, color: Colors.red),
                onPressed: () {
                  if (isSearching) {
                    setState(() {
                      isSearching = false;
                      _searchController.clear();
                      ref.watch(getContactsProvider).whenData((contacts) => _filterContacts(contacts));
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ),
        actions: [
          if (!isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.red),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contactList) {
          if (!isSearching) {
            _filteredContacts = contactList;
          }
          return ListView.builder(
            itemCount: _filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Added to match the dark background
                      ),
                    ),
                    leading: contact.photo == null?
                    //     ? CircleAvatar(
                    //   backgroundColor: Colors.grey[800],
                    //   child: Text(
                    //     contact.displayName[0],
                    //     style: const TextStyle(color: Colors.white),
                    //   ),
                    // )
                      null
                        : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/contact_model.dart';
import 'widgets/contact_form.dart';
import 'widgets/contact_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  late TextEditingController _filterController;
  List<ContactModel> _contacts = [];

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
    sharedData();
  }

  void sharedData() async {
    prefs = await SharedPreferences.getInstance();
    final String? rawContacts = prefs.getString('contacts');

    if (rawContacts != null) {
      final List<ContactModel> localContacts = ContactModel.decode(rawContacts);
      setState(() {
        _contacts = localContacts;
      });
    }
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void addContact(ContactModel contact) async {
    setState(() {
      _contacts.add(contact);
    });
    updateStorageData();
  }

  void deleteContact(String id) {
    setState(() {
      _contacts = _contacts.where((contact) => contact.id != id).toList();
    });
    updateStorageData();
  }

  void updateStorageData() async {
    final String encodedData = ContactModel.encode(_contacts);
    await prefs.setString('contacts', encodedData);
  }

  List<ContactModel> getContacts() {
    String filter = _filterController.text.toLowerCase();
    return _contacts
        .where((element) => element.name.toLowerCase().contains(filter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Phonebook'),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ContactForm(addContact: addContact),
            const SizedBox(height: 20),
            const Text(
              'Contacts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Find contact by name',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _filterController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search by name',
              ),
            ),
            const SizedBox(height: 20),
            ContactList(contacts: getContacts(), deleteContact: deleteContact),
          ],
        ),
      ),
    );
  }
}

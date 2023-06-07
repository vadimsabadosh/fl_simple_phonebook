// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import 'contact.dart';

class ContactList extends StatelessWidget {
  final List<ContactModel> contacts;
  final Function(String id) deleteContact;

  const ContactList({
    Key? key,
    required this.contacts,
    required this.deleteContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Contact(
              contact: contacts[index], deleteContact: deleteContact);
        },
        itemCount: contacts.length,
      ),
    );
  }
}

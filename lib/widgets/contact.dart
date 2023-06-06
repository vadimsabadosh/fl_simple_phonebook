// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/contact_model.dart';

class Contact extends StatelessWidget {
  final ContactModel contact;
  final Function(String id) deleteContact;
  const Contact({
    Key? key,
    required this.contact,
    required this.deleteContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Text('${contact.name} : ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Text(contact.phone, style: TextStyle(fontSize: 16)),
        ]),
        OutlinedButton(
            onPressed: () {
              deleteContact(contact.id);
            },
            child: Text('Delete'))
      ]),
    );
  }
}

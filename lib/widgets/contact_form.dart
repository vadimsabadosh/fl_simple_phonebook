// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/contact_model.dart';

class ContactForm extends StatefulWidget {
  final Function(ContactModel contact) addContact;
  const ContactForm({
    Key? key,
    required this.addContact,
  }) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidate = AutovalidateMode.disabled;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void onAddContact() {
    String name = _nameController.text;
    String phone = _phoneController.text;
    widget.addContact(ContactModel(
        name: name.toCapitalize(), phone: phone, id: generateId()));
    _nameController.text = '';
    _phoneController.text = '';
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState?.save(),
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
          validator: (val) {
            if (val!.isEmpty) return 'Enter name';
            if (val.isValidName) return 'Enter valid name';
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phoneController,
          validator: (value) {
            if (value!.isEmpty) return 'Enter phone';
            if (!_isNumeric(value)) return 'Invalid value';
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (validate()) {
              _formKey.currentState!.save();
              onAddContact();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ]),
    );
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  bool validate() {
    if (_formKey.currentState!.validate()) {
      return true;
    } else {
      autovalidate = AutovalidateMode.always;
    }
    return false;
  }
}

extension StringExtension on String {
  String toCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  // bool get isValidEmail {
  //   final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //   return emailRegExp.hasMatch(this);
  // }

  bool get isValidName {
    final nameRegExp =
        new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  // bool get isValidPassword {
  //   final passwordRegExp = RegExp(
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
  //   return passwordRegExp.hasMatch(this);
  // }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

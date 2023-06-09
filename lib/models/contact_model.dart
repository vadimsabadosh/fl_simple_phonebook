import 'dart:convert';

class ContactModel {
  String name;
  String phone;
  String id;
  ContactModel({
    required this.name,
    required this.phone,
    required this.id,
  });

  factory ContactModel.fromJson(Map<String, dynamic> jsonData) {
    return ContactModel(
      id: jsonData['id'],
      name: jsonData['name'],
      phone: jsonData['phone'],
    );
  }

  static Map<String, dynamic> toMap(ContactModel contact) => {
        'id': contact.id,
        'name': contact.name,
        'phone': contact.phone,
      };

  static String encode(List<ContactModel> contacts) => json.encode(
        contacts
            .map<Map<String, dynamic>>((music) => ContactModel.toMap(music))
            .toList(),
      );

  static List<ContactModel> decode(String contacts) =>
      (json.decode(contacts) as List<dynamic>)
          .map<ContactModel>((item) => ContactModel.fromJson(item))
          .toList();
}

import 'package:axolon_task/model/contact.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePageController extends ChangeNotifier {
  final contactsdb = Hive.box<ContactModel>("contacts");
  bool? edit = false;
  List<ContactModel?> contacts = [];
  Filter filter = Filter.name;
  ContactModel? selectedContact;

  Future<List<ContactModel>> fetchContacts() async {
    contacts.clear();
    contacts = contactsdb.values.toList();
    notifyListeners();
    return contacts.cast();
  }

  filterContacts(Filter newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  selectContact(ContactModel? contact) {
    selectedContact = contact;
    notifyListeners();
  }

  editContact(bool? editstatus) {
    edit = editstatus;
    notifyListeners();
  }

  addcontacts({required ContactModel contact}) {
    try {
      if (contacts.contains(contact)&&edit!=true) {
        throw Exception("User already exists");
      } else if (contacts
          .where((element) => element?.name == contact.name)
          .isNotEmpty&&edit!=true) {
        throw Exception("Contact name already exists");
      } else {
        contactsdb.put(contact.id, contact);
      }
      editContact(null);
      notifyListeners();
      fetchContacts();
    } catch (e) {
      rethrow;
    }
  }

  deleteContact(ContactModel contact) {
    contactsdb.delete(contact.id);
    fetchContacts();
  }
}

enum Filter { name, number, group, email }

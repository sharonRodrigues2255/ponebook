import 'package:axolon_task/controller/home_page.dart';
import 'package:axolon_task/model/contact.dart';
import 'package:axolon_task/view/contact_details.dart';
import 'package:flutter/material.dart';

class ContactSearchDelegate extends SearchDelegate<ContactModel?> {
  final HomePageController provider;

  ContactSearchDelegate(this.provider);

  @override
  String get searchFieldLabel {
    return 'Search ${_getSearchLabel()}';
  }

  String _getSearchLabel() {
    switch (provider.filter) {
      case Filter.name:
        return 'Names';
      case Filter.number:
        return 'Numbers';
      case Filter.email:
        return 'Emails';
      case Filter.group:
        return 'Groups';
      default:
        return 'Contacts';
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredContacts = provider.contacts.where((contact) {
      switch (provider.filter) {
        case Filter.name:
          return contact!.name!.toLowerCase().contains(query.toLowerCase());
        case Filter.number:
          return contact!.phone!.contains(query);
        case Filter.email:
          return contact!.email!.toLowerCase().contains(query.toLowerCase());
        case Filter.group:
          return contact!.group!.toLowerCase().contains(query.toLowerCase());
        default:
          return false;
      }
    }).toList();

    return ListView.builder(
      itemCount: filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = filteredContacts[index];
        return ListTile(
          title: Text( provider.filter == Filter.name
                        ? contact?.name ?? ""
                        : provider.filter == Filter.email
                            ? contact?.email ?? ""
                            : provider.filter == Filter.group
                                ? contact?.group ?? ""
                                : contact?.phone ?? "",),
          subtitle: Text(contact?.phone??""),
          onTap: () {
            provider.selectContact(contact);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactDetails(),
            ));
          },
        );
      },
    );
  }
}

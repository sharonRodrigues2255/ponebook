import 'dart:io';

import 'package:axolon_task/controller/home_page.dart';
import 'package:axolon_task/model/contact.dart';
import 'package:axolon_task/utils/constants/color_constants.dart';
import 'package:axolon_task/view/add_contact.dart';
import 'package:axolon_task/view/contact_details.dart';
import 'package:axolon_task/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final provider = Provider.of<HomePageController>(context, listen: false);
    Future.delayed(Duration.zero).then((value) {
      provider.fetchContacts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageController>(context);

    return Scaffold(
        floatingActionButton: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddContact()));
            },
            child: CircleAvatar(
                radius: 30,
                backgroundColor: ColorConstants.primarycolor,
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )))),
        appBar: AppBar(
          actions: [
            GestureDetector(onTap:()async {
                final selectedContact = await showSearch<ContactModel?>(
          context: context,
          delegate: ContactSearchDelegate(provider));
            },
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            PopupMenuButton<Filter>(
              icon: const Icon(
                Icons.sort,
                color: Colors.white,
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: Filter.name,
                  child: Text("Name"),
                ),
                PopupMenuItem(
                  value: Filter.number,
                  child: Text("Number"),
                ),
                PopupMenuItem(
                  value: Filter.email,
                  child: Text("Email"),
                ),
                PopupMenuItem(
                  value: Filter.group,
                  child: Text("Group"),
                ),
              ],
              onSelected: (value) {
                provider.filterContacts(value);
              },
            ),
          ],
          title: const Text(
            "Contacts",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorConstants.primarycolor,
        ),
        body:provider.contacts.length==0?Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(height: 200,width: 200,decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/empty.png"))),),
            Text("No contacts added",style: TextStyle(color: Colors.grey,fontSize: 24,fontWeight: FontWeight.bold),)
          ],
        ),):
         ListView.builder(
            itemCount: provider.contacts.length,
            itemBuilder: (context, index) {
       
              final contact = provider.contacts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                            provider.selectContact(contact!);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ContactDetails()));
                  },
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'delete') {
                      provider.deleteContact(contact!);
                    } else if (value == "edit") {
                      provider.editContact(true);
                      provider.selectContact(contact!);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddContact()));
                    }
                  }, itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Edit"),
                      )
                    ];
                  }),
                leading: CircleAvatar(
  foregroundImage: contact?.photo != null ? FileImage(File(contact!.photo!)) : null,
  backgroundColor: ColorConstants.primarycolor,
  radius: 25,
  child: contact?.photo == null
      ? Center(
          child: contact?.name != null && contact?.name != ''
              ? Text(
                  contact!.name![0],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        )
      : null,
),
                  title: Text(
                    provider.filter == Filter.name
                        ? contact?.name ?? ""
                        : provider.filter == Filter.email
                            ? contact?.email ?? ""
                            : provider.filter == Filter.group
                                ? contact?.group ?? ""
                                : contact?.phone ?? "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(contact?.phone ?? ""),
                ),
              );
            }));
  }
}

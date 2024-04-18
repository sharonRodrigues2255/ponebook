import 'dart:io';

import 'package:axolon_task/controller/home_page.dart';
import 'package:axolon_task/model/contact.dart';
import 'package:axolon_task/utils/constants/color_constants.dart';
import 'package:axolon_task/utils/constants/spaces.dart';
import 'package:axolon_task/view/add_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageController>(context);
    final contact = provider.selectedContact;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.primarycolor,
                      image: contact?.photo == null
                          ? null
                          : DecorationImage(fit: BoxFit.cover,
                              image: FileImage(File(contact!.photo!)))),
                  height: 350,
                  child: contact?.photo == null || contact?.photo == ""
                      ? Center(
                          child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ))
                      : null),
              Positioned(
                bottom: 10,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      contact?.name ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ))),
              ),
              Positioned(
                  top: 25,
                  left: 5,
                  right: 15,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            provider.editContact(true);
                            provider.selectContact(contact!);
                             Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddContact()));
                           
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ))
                    ],
                  )),
            ],
          ),
          kheight20,
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(contact?.phone ?? ""),
            subtitle: Text(contact?.group ?? ""),
          ),
          kheight10,
          ListTile(
              leading: const Icon(Icons.email),
              title: Text(contact?.email ?? ""))
        ],
      ),
    );
  }
}

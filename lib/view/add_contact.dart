import 'dart:io';

import 'package:axolon_task/controller/add_contacts.dart';
import 'package:axolon_task/controller/home_page.dart';
import 'package:axolon_task/model/contact.dart';
import 'package:axolon_task/utils/constants/color_constants.dart';
import 'package:axolon_task/utils/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  @override
  void initState() {
    final provider = Provider.of<AddContactsProvider>(context, listen: false);
    final homeprovider =
        Provider.of<HomePageController>(context, listen: false);
    final ContactModel? selected = homeprovider.selectedContact;
    final editstatus = homeprovider.edit;
    Future.delayed(Duration.zero).then((value) {
      if (editstatus == true) {
        nameController.text = selected?.name ?? "";
        phoneController.text = selected?.phone ?? "";
        emailController.text = selected?.email ?? "";
        provider.imagepath(selected?.photo);
        provider.groupController(selected?.group);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<HomePageController>(builder: (context, homeprovider, _) {
            final provider = Provider.of<AddContactsProvider>(context);

            return GestureDetector(
              onTap: () {
                if (validateform(context)) {
                  try {

                    homeprovider.addcontacts(
                      contact: ContactModel(
                        id: homeprovider.edit == true
                            ? homeprovider.selectedContact!.id
                            : homeprovider.contacts.length,
                        name: nameController.text,
                        email: emailController.text,
                        group: provider.groupSelected,
                        phone: phoneController.text,
                        photo: provider.imageSelected,
                      ),
                    );

                   
                    nameController.clear();
                    phoneController.clear();
                    emailController.clear();
                    provider.groupController(null);
                    provider.imagepath(null);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
          kwidth10,
        ],
        title: const Text(
          "Create new contact",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConstants.primarycolor,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<AddContactsProvider>(builder: (context, provider, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                kheight20,
                Center(
                  child: InkWell(
                    onTap: () async{
                      final image =
                         await ImagePicker().pickImage(source: ImageSource.gallery);

                      provider.imagepath(image?.path);
                    },
                    child: provider.imageSelected==null||provider.imageSelected==""?CircleAvatar(
                        radius: 50,
                      backgroundColor: ColorConstants.primarycolor,
                      child: const Center(
                        child:const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    
                    ): CircleAvatar(
                      foregroundImage: FileImage(File(provider.imageSelected!)),
                      radius: 50,
                      backgroundColor: ColorConstants.primarycolor,
                      child:  Center(
                        child:provider.imageSelected==null? const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ):null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                kheight10,
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length < 10) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                kheight10,
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    } else if (!RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                kheight10,
                SizedBox(
                  child: Row(
                    children: [
                      kwidth10,
                      Icon(Icons.group),
                      kwidth20,
                      DropdownButton<String>(
                        value: provider.groupSelected == ""
                            ? null
                            : provider.groupSelected,
                        hint: const Text('Select an option'),
                        onChanged: (value) {
                          provider.groupController(value);
                          print("Selected value: $value");
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "work",
                            child: Text("Work"),
                          ),
                          DropdownMenuItem(
                            value: "home",
                            child: Text("Home"),
                          ),
                          DropdownMenuItem(
                            value: "other",
                            child: Text("Other"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool validateform(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return false;
    }
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return false;
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }
    return true;
  }
}

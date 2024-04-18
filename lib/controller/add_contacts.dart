
import 'package:flutter/material.dart';


TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController emailController = TextEditingController();

class AddContactsProvider with ChangeNotifier {

  String? groupSelected = "";
  String? imageSelected = "";

 

  groupController(value) {
    groupSelected = value;
    notifyListeners();
  }

  imagepath(value) {
    imageSelected = value;

    notifyListeners();
  }
}

import 'package:axolon_task/controller/add_contacts.dart';
import 'package:axolon_task/controller/home_page.dart';
import 'package:axolon_task/model/contact.dart';
import 'package:axolon_task/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
   Hive.registerAdapter(ContactModelAdapter());
  }
 final box =await Hive.openBox<ContactModel>("contacts");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddContactsProvider()),
         ChangeNotifierProvider(create: (context) => HomePageController())
      ],
      child: MaterialApp(
        title: 'Phone book',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

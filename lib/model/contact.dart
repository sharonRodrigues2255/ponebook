import 'package:hive_flutter/hive_flutter.dart';
part 'contact.g.dart';

@HiveType(typeId: 1)
class ContactModel extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? phone;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? photo;
  @HiveField(4)
  final String? group;
  @HiveField(5)
  final int id;
  ContactModel({this.name, this.email, this.group, this.phone, this.photo,required this.id});
}

import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@Entity()
class Patient {
  @PrimaryKey()
  String? id;

  DateTime birthday;
  String sex;
  
  Patient({
    this.id,
    required this.birthday,
    required this.sex,
  });
}
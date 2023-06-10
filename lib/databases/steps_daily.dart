import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class Steps_Daily {
  @PrimaryKey()
  final String patient; 

  final String day;
  final String time;
  final int value;

  //Default constructor
  Steps_Daily(this.patient, this.day, this.time, this.value);
  
}//Todo
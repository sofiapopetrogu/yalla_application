import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class HeartDaily {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  //heart rate value
  final int heart;

  //when the step was recorded
  final DateTime dateTime;

  //patient id
  final String patient; 

  //Default constructor
  HeartDaily({this.id, required this.heart, required this.dateTime, required this.patient});
  
}//Todo
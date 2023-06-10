import 'package:project_app/databases/heart/heart_daily.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class HeartDao {
  //Query #0: SELECT -> this allows to obtain all the entries of the Heart_Daily table of a certain date
  @Query('SELECT * FROM Heart_Daily WHERE dateTime between :startTime and :endTime ORDER BY dateTime ASC')
  Future<List<Heart_Daily>> findHeartbyDate(DateTime startTime, DateTime endTime);

  //Query #1: SELECT -> this allows to obtain all the entries of the heart_daily table
  @Query('SELECT * FROM Heart_Daily')
  Future<List<Heart_Daily>> findAllHeart();

  //Query #2: INSERT -> this allows to add a row in the table
  @insert
  Future<void> insertHeart(Heart_Daily heartdaily); // void ensures that the results are not returned

  //Query #3: DELETE -> this allows to delete a row from the table
  @delete
  Future<void> deleteHeart(Heart_Daily heartdaily);

}//TodoDao
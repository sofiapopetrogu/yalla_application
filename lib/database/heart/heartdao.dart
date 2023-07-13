import 'package:project_app/database/heart/heart_daily.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class HeartDao {
  //Query #0: SELECT -> this allows to obtain all the entries of the HeartDaily table of a certain date
  @Query('SELECT * FROM HeartDaily WHERE dateTime between :startTime and :endTime ORDER BY dateTime ASC')
  Future<List<HeartDaily>> findHeartbyDate(DateTime startTime, DateTime endTime);

  //Query #1: SELECT -> this allows to obtain all the entries of the heart_daily table
  @Query('SELECT * FROM HeartDaily')
  Future<List<HeartDaily>> findAllHeart();

  //Query #2: INSERT -> this allows to add a row in the table
  @insert
  Future<void> insertHeart(HeartDaily heartdaily); // void ensures that the results are not returned
    @insert
  Future<void> insertMultHeart(List<HeartDaily> heartdaily);

  //Query #3: DELETE -> this allows to delete a row from the table
  @delete
  Future<void> deleteHeart(HeartDaily heartdaily);

  //Query #4:  Delete all entries from table
  @Query('DELETE FROM HeartDaily WHERE 1')
  Future<void> deleteAllHeart();

}//TodoDao
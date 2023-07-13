import 'package:project_app/database/steps/steps_daily.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class StepDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the steps_daily table
  @Query('SELECT * FROM StepsDaily')
  Future<List<StepsDaily>> findAllSteps();

  //Query #2: INSERT -> this allows to add a row in the table
  @insert
  Future<void> insertSteps(StepsDaily stepsdaily); // void ensures that the results are not returned
  @insert
  Future<void> insertMultSteps(List<StepsDaily> stepsdaily);

  //Query #3: DELETE -> this allows to delete a row from the table
  @delete
  Future<void> deleteSteps(StepsDaily stepsdaily);

  //Query #4:  Delete all entries from table
  @Query('DELETE FROM StepsDaily WHERE 1')
  Future<void> deleteAllSteps();


}//TodoDao
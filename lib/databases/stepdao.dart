import 'package:project_app/databases/step_table.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class StepDao {

  //Query #1: SELECT -> this allows to obtain all the entries of the Todo table
  @Query('SELECT * FROM Steps_Daily')
  Future<List<Steps_Daily>> findAllSteps();

  //Query #2: INSERT -> this allows to add a Todo in the table
  @insert
  Future<void> insertSteps(Steps_Daily steps_daily); // void ensures that the results are not returned

  //Query #3: DELETE -> this allows to delete a Todo from the table
  @delete
  Future<void> deleteSteps(Steps_Daily steps_daily);

}//TodoDao
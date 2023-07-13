import 'package:floor/floor.dart';
import 'package:project_app/database/patients/patients.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class PatientDao {

  //Query #1: SELECT -> this allows to obtain  a patient
  @Query('SELECT * FROM Patient WHERE patient == :patient')
  Future<Patient?> findPatient(int patient);

  //Query #2: INSERT -> this allows to add a Patient in the table
  @insert
  Future<void> insertPatient(Patient patients);

  //Query #3: DELETE -> this allows to delete a Patient from the table
  @delete
  Future<void> deletePatient(Patient patients);

}//PatientsDao
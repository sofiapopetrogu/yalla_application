import 'package:project_app/database/db.dart';
import 'package:project_app/database/heart/heart_daily.dart';
import 'package:project_app/database/patients/patients.dart';
import 'package:project_app/database/steps/steps_daily.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});


//Heart_Daily

  //This method wraps the findHeartbyDate() method of the DAO. 
  Future<List<Heart_Daily>> findHeartbyDate(DateTime startTime, DateTime endTime) async{
    final results = await database.heartDao.findHeartbyDate(startTime, endTime);
    return results;
  }//findHeartbyDate

  //This method wraps the findAllHeart() method of the DAO. 
  Future<List<Heart_Daily>> findAllHeart() async{
    final results = await database.heartDao.findAllHeart();
    return results;
  }//findAllHeart

  //This method wraps the insertHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertHeart(Heart_Daily heartdaily) async {
    await database.heartDao.insertHeart(heartdaily);
    notifyListeners();
  }//insertHeart

  //This method wraps the deleteHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteHeart(Heart_Daily heartdaily) async{
    await database.heartDao.deleteHeart(heartdaily);
    notifyListeners();
  }//deleteHeart

//Patients
  //This method wraps the findHeartbyDate() method of the DAO. 
  Future<Patient?> findPatient(int patient) async{
    final results = await database.patientDao.findPatient(patient);
    return results;
  }//findPatient

  //This method wraps the insertPatient() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertPatient(Patient patients) async {
    await database.patientDao.insertPatient(patients);
    notifyListeners();
  }//insertPatient

  //This method wraps the deletePatient() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deletePatient(Patient patients) async {
    await database.patientDao.deletePatient(patients);
    notifyListeners();
  }//deletePatient

//Steps_Daily
  Future<void> deleteAllSteps() async{
    await database.stepDao.deleteAllSteps();
    notifyListeners();
  }//deleteAllSteps


  //This method wraps the findAllSteps() method of the DAO. 
  Future<List<Steps_Daily>> findAllSteps() async{
    final results = await database.stepDao.findAllSteps();
    return results;
  }//findAllSteps

  //This method wraps the insertSteps() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  //Future<void> insertSteps(Steps_Daily stepsdaily) async {
  //  await database.stepDao.insertSteps(stepsdaily);
  //  notifyListeners();
  //}//insertSteps

  //This method wraps the deleteSteps() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteSteps(Steps_Daily stepsdaily) async{
    await database.stepDao.deleteSteps(stepsdaily);
    notifyListeners();
  }//deleteSteps

}//DatabaseRepository
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


//HeartDaily

  //This method wraps the findHeartbyDate() method of the DAO. 
  Future<List<HeartDaily>> findHeartbyDate(DateTime startTime, DateTime endTime) async{
    final results = await database.heartDao.findHeartbyDate(startTime, endTime);
    return results;
  }//findHeartbyDate

  //This method wraps the findAllHeart() method of the DAO. 
  Future<List<HeartDaily>> findAllHeart() async{
    final results = await database.heartDao.findAllHeart();
    return results;
  }//findAllHeart

  //This method wraps the insertHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertHeart(HeartDaily heartdaily) async {
    await database.heartDao.insertHeart(heartdaily);
    notifyListeners();
  }//insertHeart

  //This method wraps the deleteHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteHeart(HeartDaily heartdaily) async{
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

//StepsDaily
  Future<void> deleteAllSteps() async{
    await database.stepDao.deleteAllSteps();
    notifyListeners();
  }//deleteAllSteps

  Future<void> deleteAllHeart() async{
    await database.heartDao.deleteAllHeart();
    notifyListeners();
  }//deleteAllSteps

  //This method wraps the findAllSteps() method of the DAO. 
  Future<List<StepsDaily>> findAllSteps() async{
    final results = await database.stepDao.findAllSteps();
    return results;
  }//findAllSteps

  //This method wraps the deleteSteps() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteSteps(StepsDaily stepsdaily) async{
    await database.stepDao.deleteSteps(stepsdaily);
    notifyListeners();
  }//deleteSteps

}//DatabaseRepository
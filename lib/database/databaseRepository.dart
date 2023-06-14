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

  //This method wraps the findAllHeart() method of the DAO. 
  Future<List<Heart_Daily>> findAllHeart() async{
    final results = await database.heartDao.findAllHeart();
    return results;
  }//findAllHeart

  //This method wraps the insertHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertHeart(Heart_Daily heartdaily)async {
    await database.heartDao.insertHeart(heartdaily);
    notifyListeners();
  }//insertHeart

  //This method wraps the deleteHeart() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteHeart(Heart_Daily heartdaily) async{
    await database.heartDao.deleteHeart(heartdaily);
    notifyListeners();
  }//deleteHeart
  
}//DatabaseRepository
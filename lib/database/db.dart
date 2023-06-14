//Imports that are necessary to the code generation of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:project_app/typeConverters/dateTimeConverter.dart';

//Import the entities and daos of the database
import 'package:project_app/database/steps/stepdao.dart';
import 'package:project_app/database/steps/steps_daily.dart';
import 'package:project_app/database/heart/heartdao.dart';
import 'package:project_app/database/heart/heart_daily.dart';
import 'package:project_app/database/patients/patientsdao.dart';
import 'package:project_app/database/patients/patients.dart';

part 'db.g.dart'; 

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Patient, Steps_Daily, Heart_Daily])
abstract class AppDatabase extends FloorDatabase {
  PatientDao get patientDao;
  StepDao get stepDao;
  HeartDao get heartDao;
}


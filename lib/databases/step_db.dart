//Imports that are necessary to the code generation of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:project_app/typeConverters/dateTimeConverter.dart';

//Import the entities and daos of the database
import 'package:project_app/databases/stepdao.dart';
import 'package:project_app/databases/steps_daily.dart';

part 'step_db.g.dart'; 

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Steps_Daily])
abstract class StepDatabase extends FloorDatabase {
  StepDao get stepDao;
}


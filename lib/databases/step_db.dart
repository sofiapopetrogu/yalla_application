//Imports that are necessary to the code generation of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Import the entities and daos of the database
import 'package:project_app/databases/stepdao.dart';
import 'package:project_app/databases/step_table.dart';

part 'step_db.g.dart'; 

@Database(version: 1, entities: [Steps_Daily])
abstract class StepDatabase extends FloorDatabase {
  StepDao get stepDao;
}


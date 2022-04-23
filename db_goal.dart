import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'db_goal.g.dart';

class Places extends Table {
  TextColumn get strLong => text()();
  TextColumn get strMiddle => text()();
  TextColumn get strShort => text()();

  @override
  Set<Column>? get primaryKey => {strLong};
}

@DriftDatabase(tables: [Places])
class MyDbGoal extends _$MyDbGoal {
  MyDbGoal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //Create
  Future addPlace(PlacesCompanion place) async{
    return into(places).insert(place);
  }

  //Read
  Future<List<Place>> get allPlaces => select(places).get();

  //Update
  Future updateWord(PlacesCompanion place) => update(places).replace(place);

  //Delete
  Future deleteWord(Place place) =>
      (delete(places)..where((table) => table.strLong.equals(place.strLong))).go();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'goal.db'));
    return NativeDatabase(file);
  });
}
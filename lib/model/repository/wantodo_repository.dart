import 'package:wantodo/model/db/app_db.dart';
import 'package:wantodo/model/entity/wantodo.dart';

class WantodoRepository {
  final AppDatabase _appDatabase;

  WantodoRepository(this._appDatabase);

  Future<List<Wantodo>> loadAllWantodo() => _appDatabase.loadAllWantodo();

  Future<List<Wantodo>> search(String keyword) => _appDatabase.search(keyword);

  Future insert(Wantodo wantodo) => _appDatabase.insert(wantodo);

  Future update(Wantodo wantodo) => _appDatabase.update(wantodo);

  Future delete(Wantodo wantodo) => _appDatabase.delete(wantodo);
}
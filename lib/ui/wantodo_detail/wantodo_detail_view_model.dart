import 'package:flutter/material.dart';
import 'package:wantodo/model/entity/wantodo.dart';
import 'package:wantodo/model/repository/wantodo_repository.dart';
import 'package:uuid/uuid.dart';

class WantodoDetailViewModel extends ChangeNotifier {
  final WantodoRepository _repository;

  WantodoDetailViewModel(wantodo, this._repository) {
    _wantodo = wantodo ?? initWantodo();
    _isNew = (wantodo == null);
    _detailCounts = _wantodo.detail.length;
    notifyListeners();
  }

  late Wantodo _wantodo;

  Wantodo get wantodo => _wantodo;

  late bool _isNew;

  bool get isNew => _isNew;

  int _detailCounts = 0;

  int get detailCounts => _detailCounts;

  Wantodo initWantodo() {
    return Wantodo(
      id: Uuid().v4(),
      title: '',
      detail: '',
      status: 'TODO',
      createdAt: DateTime.now(), // sho: 微妙
    );
  }

  void setTitle(String title) {
    _wantodo.title = title;
    notifyListeners();
  }

  void setContent(String detail) {
    _wantodo.detail = detail;
    _detailCounts = detail.length;
    notifyListeners();
  }

  Future save() async {
    _wantodo.createdAt = DateTime.now();
    return await _repository.insert(_wantodo);
  }

  Future update() async {
    _wantodo.createdAt = DateTime.now();
    return await _repository.update(_wantodo);
  }

  Future delete() async => _repository.delete(_wantodo);
}
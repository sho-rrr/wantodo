import 'package:flutter/material.dart';
import 'package:wantodo/model/entity/wantodo.dart';
import 'package:wantodo/model/repository/wantodo_repository.dart';

class WantodoListViewModel extends ChangeNotifier {
  final WantodoRepository _repository;

  WantodoListViewModel(this._repository) {
    loadAllWantodo();
  }

  List<Wantodo> _wantodos = [];

  List<Wantodo> get wantodos => _wantodos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void loadAllWantodo() async {
    _startLoading();
    _wantodos = await _repository.loadAllWantodo();
    _finishLoading();
  }

  void search(String keyword) async {
    _startLoading();
    _wantodos = await _repository.search(keyword);
    _finishLoading();
  }

  void updateDone(int index) async {
    _startLoading();
    _wantodos[index].setDone();
    _repository.update(_wantodos[index]);
    _finishLoading();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
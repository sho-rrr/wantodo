import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantodo/model/db/app_db.dart';
import 'package:wantodo/model/entity/wantodo.dart';
import 'package:wantodo/model/repository/wantodo_repository.dart';
import 'package:wantodo/ui/wantodo_detail/wantodo_detail_view_model.dart';

class WantodoDetail extends StatelessWidget {
  final Wantodo? _wantodo;

  WantodoDetail(this._wantodo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WantodoDetailViewModel(_wantodo, WantodoRepository(AppDatabase())),
      child: _WantodoDetailPage(),
    );
  }
}

class _WantodoDetailPage extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WantodoDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.isNew ? '登録' : '編集'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _showSaveOrUpdateDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: vm.isNew ? null : () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'タイトル'),
                initialValue: vm.isNew ? '' : vm.wantodo.title,
                validator: (value) => (value == null || value.isEmpty) ? 'タイトルを入力して下さい' : null,
                onChanged: (value) => vm.setTitle(value),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'メモ'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: vm.isNew ? '' : vm.wantodo.detail,
                  onChanged: (value) => vm.setContent(value),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${vm.detailCounts} 文字'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveOrUpdateDialog(BuildContext context) {
    if (_globalKey.currentState == null) return;
    if (!_globalKey.currentState!.validate()) return;

    var vm = Provider.of<WantodoDetailViewModel>(context, listen: false);

    bool isNew = vm.isNew;

    String saveOrUpdateText = (isNew ? '保存' : '更新');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('メモを$saveOrUpdateTextしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () =>
                  isNew ? _save(context, vm) : _update(context, vm),
              child: Text(saveOrUpdateText),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    var vm = Provider.of<WantodoDetailViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('メモを削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => _delete(context, vm),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }

  void _save(BuildContext context, WantodoDetailViewModel vm) async {
    _showIndicator(context);
    await vm.save();
    _goToWantodoListScreen(context);
  }

  void _update(BuildContext context, WantodoDetailViewModel vm) async {
    _showIndicator(context);
    await vm.update();
    _goToWantodoListScreen(context);
  }

  void _delete(BuildContext context, WantodoDetailViewModel vm) async {
    _showIndicator(context);
    await vm.delete();
    _goToWantodoListScreen(context);
  }

  void _showIndicator(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (
        BuildContext context,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _goToWantodoListScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
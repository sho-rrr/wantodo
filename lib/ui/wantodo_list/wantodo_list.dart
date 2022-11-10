import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantodo/ui/wantodo_detail/wantodo_detail.dart';
import 'package:wantodo/ui/wantodo_list/wantodo_list_view_model.dart';
import 'package:wantodo/model/db/app_db.dart';
import 'package:wantodo/model/entity/wantodo.dart';
import 'package:wantodo/model/repository/wantodo_repository.dart';

class WantodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = WantodoListViewModel(WantodoRepository(AppDatabase()));
    final page = _WantodoListPage();
    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Scaffold(
        // AppBarにTextFieldを配置することで、検索バーになる
        appBar: AppBar(
          title: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'タイトルを検索',
              hintStyle: const TextStyle(color: Colors.white),
            ),
            onChanged: (value) => vm.search(value),
          ),
        ),
        backgroundColor: Color(0xffF2F2F2),
        body: page,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
	  // メモ登録画面に遷移する
          onPressed: () => page.goToWantodoDetailScreen(context, null),
        ),
      ),
    );
  }
}

class _WantodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WantodoListViewModel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.wantodos.isEmpty) {
      return const Center(child: const Text('メモが登録されていません'));
    }

    return ListView.builder(
      itemCount: vm.wantodos.length,
      itemBuilder: (BuildContext context, int index) {
        var wantodo = vm.wantodos[index];
        return _buildWantodoListTile(context, wantodo);
      },
    );
  }

  Widget _buildWantodoListTile(BuildContext context, Wantodo wantodo) {
    return Card(
      child: ListTile(
        title: Text(
          wantodo.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(wantodo.getDetail()),
        trailing: Text(wantodo.getCreatedAt()),
	// メモ編集・削除画面に遷移する
        onTap: () => goToWantodoDetailScreen(context, wantodo),
      ),
    );
  }

  void goToWantodoDetailScreen(BuildContext context, Wantodo? wantodo) {
    var route = MaterialPageRoute(
      settings: RouteSettings(name: '/ui.wantodo_detail'),
      builder: (BuildContext context) => WantodoDetail(wantodo),
    );
    Navigator.push(context, route);
  }
}
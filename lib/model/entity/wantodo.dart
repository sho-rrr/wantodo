import 'package:intl/intl.dart';

class Wantodo {
  String id;
  String title;
  String detail;
  String status;
  DateTime createdAt;
  DateTime? doneAt;

  String getDetail() {
    String cont = detail.replaceAll('\n', ' ');
    if (cont.length <= 10) return cont;
    return '${cont.substring(0, 10)}...';
  } // 使わないかも

  String getCreatedAt() {
    try {
      var fomatter = DateFormat('yyyy/MM/dd HH:mm:ss', 'ja_JP');
      return fomatter.format(createdAt);
    } catch (e) {
      print(e);
      return '';
    }
  }

  Wantodo({
    required this.id,
    required this.title,
    required this.detail,
    required this.status,
    required this.createdAt,
    this.doneAt
  });
}
import 'package:calculator/main.dart';
import 'package:firebase_database/firebase_database.dart';

class Message {
  String? key;
  final List<num> nums;
  final num? result;
  final DateTime datetime;
  final List<String> opers;
  final String? author;
  final String? authorId;

  Message(this.nums, this.opers, this.result, this.datetime, this.authorId,
      this.author);

  Message.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nums = snapshot.value['numbers'].cast<num>(),
        opers = snapshot.value['operands'].cast<String>(),
        result = snapshot.value['result'],
        datetime = DateTime.parse(snapshot.value['datetime']),
        authorId = snapshot.value['authorId'],
        author = snapshot.value['author'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'numbers': nums,
        'operands': opers,
        'result': result,
        'datetime': datetime.toString(),
        'author_id': authorId,
        'author': author
      };
}

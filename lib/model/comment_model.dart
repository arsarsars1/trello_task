import 'package:hive/hive.dart';
import 'package:task_tracker_pro/model/contact.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 2)
class CommentModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String comment;
  @HiveField(2)
  final String createdAt;
  @HiveField(3)
  final Contact author;

  CommentModel({
    required this.id,
    required this.author,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author.toJson(),
        'comment': comment,
        'createdAt': createdAt,
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      author: Contact.fromJson(json['author']),
      comment: json['comment'],
      createdAt: json['createdAt'],
    );
  }
}
